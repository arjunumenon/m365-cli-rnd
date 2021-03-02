#!/bin/bash

# requires jq: https://stedolan.github.io/jq/

defaultIFS=$IFS
IFS=$'\n'

#Ensure that you are logged in to the site mentioned in the webURL as a user who has Edit Permission
webURL="https://aum365.sharepoint.com/sites/M365CLI"
listName="M365HealthStatus"
#Email address to which an outage email will be sent
notifyEmail="arjun@aum365.onmicrosoft.com"

CurrentList=$(m365 spo list get --webUrl $webURL --title "$listName" --output json)

if [ -z "$CurrentList" ]
then
      echo "List does not exist. Hence creating the SharePoint List"
      CurrentList=$(m365 spo list add --baseTemplate GenericList --webUrl $webURL --title "$listName")

      #Adding Fields to the List
      FieldLists='[{"fieldname":"Workload","fieldtype":"Text"},
      {"fieldname":"FirstIdentifiedDate","fieldtype":"DateTime"},
      {"fieldname":"WorkflowJSONData","fieldtype":"Note"}]'
      for field in $(echo $FieldLists | jq -c '.[]'); do
            addedField=$(m365 spo field add --webUrl $webURL --listTitle "$listName" --xml "<Field Type='$(echo $field | jq -r ''.fieldtype)' DisplayName='$(echo $field | jq -r ''.fieldname)' Required='FALSE' EnforceUniqueValues='FALSE' Indexed='FALSE' StaticName='$(echo $field | jq -r ''.fieldname)' Name='$(echo $field | jq -r ''.fieldname)'></Field>" --options  AddFieldToDefaultView)
      done

      echo "Created SharePoint List $listName for logging the Outages."
fi

#Getting current status and do the needed operation
workLoads=$(m365 tenant status list --query "value[?Status != 'ServiceOperational']"  --output json)
currentOutageServices=$(m365 spo listitem list --webUrl $webURL --title "$listName" --fields "Title, Workload, Id"  --output json)

#Checking for any new outages
updateSinceLastExecution=false
echo $'\n### New Outages ###'
for workLoad in $(echo $workLoads | jq -r '.[].Workload'); do
      if [ -z $(echo $currentOutageServices | jq -r '.[].Workload | select(. == "'"$workLoad"'")') ]  
      then            
            addingWorkload=$(echo $workLoads | jq -r '.[] | select(.Workload == "'"$workLoad"'")')
            
            #Add outage information to SharePoint List
            epochTimeDate=$(date -d "$(echo $addingWorkload | jq -r '.StatusTime')" +%s)
            formattedDate=$(date -d @$(echo $epochTimeDate) '+%m/%d/%Y %H:%M:%S')
            addedRecord=$(m365 spo listitem add --webUrl $webURL --listTitle "$listName" --contentType Item --Title "$(echo $addingWorkload | jq -r '.WorkloadDisplayName')" --Workload "$(echo $addingWorkload | jq -r '.Workload')" --FirstIdentifiedDate "$(echo $formattedDate)" --WorkflowJSONData "$(echo $addingWorkload | jq -r '.')")
            
            #Send notification using CLI Commands
            m365 outlook mail send --to $notifyEmail --subject "Outage Reported in $(echo $addingWorkload | jq -r '.WorkloadDisplayName')" --bodyContents "An outage has been reported for the Service : $(echo $addingWorkload | jq -r '.WorkloadDisplayName') <a href='$webURL/Lists/$listName'>Access the Health Status List</a>" --bodyContentType HTML --saveToSentItems false
            
            echo "Outage is Reported for Service : $(echo $addingWorkload | jq -r '.WorkloadDisplayName'). Please access \"$webURL/Lists/$listName\" for more information"
            updateSinceLastExecution=true
      fi
done
if [ "$updateSinceLastExecution" = false ] ; 
      then
            echo "NO New Outages are reported yet."
fi

#Checking whether any existing outages are resolved
updateSinceLastExecution=false
echo $'\n### Resolved Outages ###'
for service in $(echo $currentOutageServices | jq -r '.[].Workload'); do
      if [ -z $(echo $workLoads | jq -r '.[].Workload | select(. == "'"$service"'")') ]  
      then
            removalService=$(echo $currentOutageServices | jq -r '.[] | select(.Workload == "'"$service"'")')

            #Removing the outage information from SharePoint List
            removedService=$(m365 spo listitem remove --webUrl $webURL --listTitle "$listName" --id $(echo $removalService | jq -r '.Id') --confirm)
            
            #Send notification using CLI Commands
            m365 outlook mail send --to $notifyEmail --subject "Outage RESOLVED for $(echo $removalService | jq -r '.Title')" --bodyContents "Outage which was reported for the Service : $(echo $removalService | jq -r '.Title') is RESOLVED." --bodyContentType HTML --saveToSentItems false

            echo "Outage which was reported for the Service : $(echo $removalService | jq -r '.Title') is now RESOLVED."
            updateSinceLastExecution=true
      fi
done
if [ "$updateSinceLastExecution" = false ] ; 
      then
            echo "No further updates on the existing outages"
fi
