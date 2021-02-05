# defaultIFS=$IFS
# IFS=$'\n'


FieldLists='[{"fieldname":"Workload","fieldtype":"Text"},{"fieldname":"FirstIdentifiedDate","fieldtype":"DateTime"}]'


echo "${FieldLists}" | jq '.[].fieldtype'

# # jq -c '.[]' $FieldLists.json | while read i; do
# #     echo $i
# # done

# echo "${FieldLists}" | jq | while read i; do
#     echo "arjun"
# done

return


webURL="https://aum365.sharepoint.com/sites/M365CLI"
listName="M365 Health Statu"
CurrentList=$(m365 spo list get --webUrl $webURL --title "$listName" --output json)

if [ -z "$CurrentList" ]
then
      echo "List does not exist. Hence creating the SharePoint List"
      CurrentList=$(m365 spo list add --baseTemplate GenericList --webUrl $webURL --title "$listName")
fi