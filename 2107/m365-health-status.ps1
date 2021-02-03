$siteURL = "https://aum365.sharepoint.com/sites/M365CLI"
$listName = "M365 Health Status"

$CurrentList = (m365 spo list get --title $listName --webUrl $siteURL --output json) | ConvertFrom-Json

#Checking List exists. Will create the list if the List doest not exist
if($CurrentList -eq $null){
    Write-Host "Creating the List"

    #Creating the list
    #m365 spo list add  --baseTemplate GenericList --title $listName --webUrl  $siteURL

    m365 spo list add --title $listName --baseTemplate GenericList --webUrl $siteURL --schemaXml "" --debug
    #Adding the fields
    #m365 spo field add --webUrl $siteURL --listTitle 'M365 Health Status' --xml "<Field Type='Text' DisplayName='Work Load' Required='FALSE' EnforceUniqueValues='FALSE' Indexed='FALSE' ID='{6085e32a-339b-4da7-ab6d-c1e013e5ab27}' SourceID='{4f118c69-66e0-497c-96ff-d7855ce0713d}' StaticName='workLoad' Name='workLoad' InternalName='workLoad'></Field>"

    #m365 spo field add --webUrl $siteURL --listTitle 'M365 Health Status' --xml "<Field AppendOnly='FALSE' DisplayName='WorkflowJSONData' Format='Dropdown' IsModern='TRUE' IsolateStyles='FALSE' RichText='FALSE' RichTextMode='Compatible' Type='Note' ID='{9fb30bda-51dd-4c2f-96f5-25c96c04db44}' SourceID='{3209092b-1b9b-4742-9e6e-6a71a2b7ca0b}' StaticName='WorkflowJSONData' ColName='ntext2' RowOrdinal='0' />"

}
else{
    #DUMMY SCRIPT - REMOVE LIST
    m365 spo list remove --webUrl $siteURL --title $listName --confirm
    ##ND OF DUMMY
}

