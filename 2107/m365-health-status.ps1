$siteURL = "https://aum365.sharepoint.com/sites/M365CLI"
$listName = "M365 Health Status"

$CurrentList = (m365 spo list get --title $listName --webUrl $siteURL --output json) | ConvertFrom-Json

#Checking List exists. Will create the list if the List doest not exist
if($CurrentList -eq $null){
    Write-Host "Creating the List"

    #Creating the list
    m365 spo list add  --baseTemplate GenericList --title $listName --webUrl  $siteURL

    #m365 spo list add --baseTemplate GenericList --webUrl $siteURL --title $listName --schemaXml "<List xmlns:ows='Microsoft SharePoint' xmlns='http://schemas.microsoft.com/sharepoint/'><MetaData><Fields><Field ID='{fa564e0f-0c70-4ab9-b863-0177e6ddd247}' Type='Text' Name='Title' DisplayName='Title' Required='TRUE' SourceID='http://schemas.microsoft.com/sharepoint/v3' StaticName='Title' MaxLength='255' /></Fields></MetaData></List>" --output json
    #Adding the fields
    #m365 spo field add --webUrl $siteURL --listTitle 'M365 Health Status' --xml "<Field Type='Text' DisplayName='Work Load' Required='FALSE' EnforceUniqueValues='FALSE' Indexed='FALSE' ID='{6085e32a-339b-4da7-ab6d-c1e013e5ab27}' SourceID='{4f118c69-66e0-497c-96ff-d7855ce0713d}' StaticName='workLoad' Name='workLoad' InternalName='workLoad'></Field>"

}
else{
    #DUMMY SCRIPT - REMOVE LIST
    #m365 spo list remove --webUrl $siteURL --title $listName --confirm
    ##ND OF DUMMY
}

