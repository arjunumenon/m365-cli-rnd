$siteURL = "https://aum365.sharepoint.com/sites/M365CLI"
$listName = "M365 Health Status"

$CurrentList = (m365 spo list get --title $listName --webUrl $siteURL --output json) | ConvertFrom-Json

#Checking List exists. Will create the list if the List doest not exist
if($CurrentList -eq $null){
    Write-Host "Creating the List"

    #Creating the list - Conventional
    m365 spo list add  --baseTemplate GenericList --title $listName --webUrl  $siteURL

    #Adding the fields
    m365 spo field add --webUrl $siteURL --listTitle 'M365 Health Status' --xml "<Field Type='Text' DisplayName='WorkLoad' Required='FALSE' EnforceUniqueValues='FALSE' Indexed='FALSE' StaticName='workLoad' Name='workLoad'></Field>" --options  AddFieldToDefaultView
    m365 spo field add --webUrl $siteURL --listTitle 'M365 Health Status' --xml "<Field Type='DateTime' DisplayName='FirstIdentifiedDate' Required='FALSE' EnforceUniqueValues='FALSE' Indexed='FALSE' StaticName='FirstIdentifiedDate' Name='FirstIdentifiedDate'></Field>" --options  AddFieldToDefaultView
    m365 spo field add --webUrl $siteURL --listTitle 'M365 Health Status' --xml "<Field Type='Note' DisplayName='WorkflowJSONData' Required='FALSE' EnforceUniqueValues='FALSE' Indexed='FALSE' StaticName='WorkflowJSONData' Name='WorkflowJSONData'></Field>" --options  AddFieldToDefaultView
    m365 spo field add --webUrl $siteURL --listTitle 'M365 Health Status' --xml "<Field Type='Boolean' DisplayName='StillinOutage' Required='FALSE' EnforceUniqueValues='FALSE' Indexed='FALSE' StaticName='StillinOutage' Name='StillinOutage'></Field>" --options  AddFieldToDefaultView
}
else{
    #DUMMY SCRIPT - REMOVE LIST
    m365 spo list remove --webUrl $siteURL --title $listName --confirm
    ##ND OF DUMMY
}


