# defaultIFS=$IFS
# IFS=$'\n'

webURL="https://aum365.sharepoint.com/sites/M365CLI"
listName="M365 Health StatusBASH"
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
fi

#Getting current status and do the needed operation
workLoads=$(m365 tenant status list --query "value[?Status != 'ServiceOperational']"  --output json)
currentOutageServices=$(m365 spo listitem list --webUrl $webURL --title "$listName" --fields "Title, Workload, Id"  --output json)

#echo $currentOutageServices
#echo $workLoads

#Dummy Change

#Checking for any new outages
for workLoad in $(echo $workLoads | jq -r '.[].Workload'); do

      if [ -z $(echo $currentOutageServices | jq -r '.[].Title | select(. == "'"$workLoad"'")') ]  
      then
            echo "$workLoad NOPE"
            #addedRecord=$(m365 spo listitem add --webUrl $webURL --listTitle "$listName" --contentType Item --Title $workload.WorkloadDisplayName --Workload $workload.Workload --FirstIdentifiedDate (Get-Date -Date $workload.StatusTime -Format "MM/dd/yyyy HH:mm") --WorkflowJSONData (Out-String -InputObject $workload -Width 100))
      else
            echo "$workLoad Exists"
      fi
done
