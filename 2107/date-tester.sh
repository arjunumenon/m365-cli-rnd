# dateTemp="2021-02-25T14:16:56.1242048Z"

# #startd=$(date -d "$dateTemp" "+%Y-%m-%d %H:%M:%S")

# #SharePoint Date
# startd=$(date -d "$dateTemp" '+%m/%d/%Y %H:%M:%S')


restDateValue="2021-02-25T14:16:56.1242048Z"

epochTimeDate=$(date -d "$restDateValue" +%s)

formattedDate=$(date -d @$(echo $epochTimeDate) '+%m/%d/%Y %H:%M:%S')

echo $formattedDate

# startd=$(date -j -f "%Y-%m-%d %H:%M" "2015-06-11 12:39")


# startd=$(date -d "$dateTemp" +%F2021)

# echo $startd)  %H
