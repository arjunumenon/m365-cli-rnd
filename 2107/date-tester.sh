dateTemp="2021-02-25T14:16:56.1242048Z"

#startd=$(date -d "$dateTemp" "+%Y-%m-%d %H:%M:%S")

#SharePoint Date
startd=$(date -d "$dateTemp" '+%m/%d/%Y %H:%M:%S')



echo $startd