$siteURL = "https://aum365.sharepoint.com/sites/M365CLI"
$listName = "M365 Health Status"

$CurrentList = (m365 spo list get --title $listName --webUrl $siteURL --output json) | ConvertFrom-Json

#Checking List exists. Will create the list if the List doest not exist
if($CurrentList -eq $null){
    Write-Host "Creating the List"

    #Creating the list
    m365 spo list add  --baseTemplate GenericList --title $listName --webUrl  $siteURL

    #Adding the fields
    m365 spo field add --webUrl $siteURL --listTitle 'M365 Health Status' --xml "<Field Type='URL' DisplayName='More information link' Required='FALSE' EnforceUniqueValues='FALSE' Indexed='FALSE' Format='Hyperlink' Group='PnP Columns' ID='{6085e32a-339b-4da7-ab6d-c1e013e5ab27}' SourceID='{4f118c69-66e0-497c-96ff-d7855ce0713d}' StaticName='PnPAlertMoreInformation' Name='PnPAlertMoreInformation'></Field>"

}
else{
    #DUMMY SCRIPT - REMOVE LIST
    m365 spo list remove --webUrl $siteURL --title $listName --confirm
    ##ND OF DUMMY
}

