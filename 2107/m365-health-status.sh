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
            echo $field | jq ''.fieldname
            echo $field | jq ''.fieldtype
            m365 spo field add --webUrl $webURL --listTitle "$listName" --xml "<Field Type='$(echo $field | jq ''.fieldtype)' DisplayName='$(echo $field | jq ''.fieldname)' Required='FALSE' EnforceUniqueValues='FALSE' Indexed='FALSE' StaticName='$(echo $field | jq ''.fieldname)' Name='$(echo $field | jq ''.fieldname)'></Field>" --options  AddFieldToDefaultView --debug
            #$addedField = $(m365 spo field add --webUrl $webURL --listTitle "$listName" --xml "<Field Type='$(echo $field | jq ''.fieldtype)' DisplayName='$(echo $field | jq ''.fieldname)' Required='FALSE' EnforceUniqueValues='FALSE' Indexed='FALSE' StaticName='$(echo $field | jq ''.fieldname)' Name='$(echo $field | jq ''.fieldname)'></Field>" --options  AddFieldToDefaultView)
      done
fi