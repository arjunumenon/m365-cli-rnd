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
            fieldName=$(echo $field | jq -r ''.fieldname)
            fieldType=$(echo $field | jq -r ''.fieldtype)

            echo $fieldName
            echo $fieldType
            #m365 spo field add --webUrl $webURL --listTitle "$listName" --xml "<Field Type='$fieldType' DisplayName='$fieldName' Required='FALSE' EnforceUniqueValues='FALSE' Indexed='FALSE' StaticName='$fieldName' Name='$fieldName'></Field>" --options  AddFieldToDefaultView --debug
            addedField=$(m365 spo field add --webUrl $webURL --listTitle "$listName" --xml "<Field Type='$(echo $field | jq -r ''.fieldtype)' DisplayName='$(echo $field | jq -r ''.fieldname)' Required='FALSE' EnforceUniqueValues='FALSE' Indexed='FALSE' StaticName='$(echo $field | jq -r ''.fieldname)' Name='$(echo $field | jq -r ''.fieldname)'></Field>" --options  AddFieldToDefaultView)
      done
fi