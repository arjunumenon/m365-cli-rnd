#Ensure that you are logged in to the site mentioned in the webURL as a user who has Edit Permission
$webURL = "https://aum365.sharepoint.com/sites/M365CLI"
$listName = "M365HealthStatus"
#Email address to which an outage email will be sent
$notifyEmail = "arjun@aum365.onmicrosoft.com"

$CurrentList = (m365 spo list get --title $listName --webUrl $webURL --output json) | ConvertFrom-Json

#Checking whether List exists. Will create the list if the List doest not exist
if($CurrentList -eq $null){
    Write-Host "List does not exist. Hence creating the SharePoint List"

    #Creating the list - Conventional
    $CurrentList = m365 spo list add  --baseTemplate GenericList --title $listName --webUrl  $webURL
    #Adding the fields
    $FieldLists = @(
    @{fieldname="Workload";fieldtype="Text";},@{fieldname="FirstIdentifiedDate";fieldtype="DateTime";},@{fieldname="WorkflowJSONData";fieldtype="Note";}
    )
    Foreach ($field in $FieldLists){
        $addedField = m365 spo field add --webUrl $webURL --listTitle $listName --xml "<Field Type='$($field.fieldtype)' DisplayName='$($field.fieldname)' Required='FALSE' EnforceUniqueValues='FALSE' Indexed='FALSE' StaticName='$($field.fieldname)' Name='$($field.fieldname)'></Field>" --options  AddFieldToDefaultView
    }
    Write-Host "Created SharePoint List $listName for logging the Outages."
}

#Getting current Tenant Status and do the needed operations
$workLoads = m365 tenant status list --query "value[?Status != 'ServiceOperational']"  --output json  | ConvertFrom-Json
$currentOutageServices = (m365 spo listitem list --webUrl $webURL --title $listName --fields "Title, Workload, Id"  --output json).Replace("ID", "_ID") | ConvertFrom-Json

#Checking for any new outages
$updateSinceLastExecution = $false
Write-Host "`n### New Outages ###"
Foreach ($workload in $workLoads){
    if($workload.Workload -notin $currentOutageServices.Workload){
        #Add outage information to SharePoint List
        $addedWorkLoad = m365 spo listitem add --webUrl $webURL --listTitle $listName --contentType Item --Title $workload.WorkloadDisplayName --Workload $workload.Workload --FirstIdentifiedDate (Get-Date -Date $workload.StatusTime -Format "MM/dd/yyyy HH:mm") --WorkflowJSONData (Out-String -InputObject $workload -Width 100)

        #Send notification using CLI Commands
        m365 outlook mail send --to $notifyEmail --subject "Outage Reported in $($workload.WorkloadDisplayName)" --bodyContents "An outage has been reported for the Service : $($workload.WorkloadDisplayName) <a href='$webURL/Lists/$listName'>Access the Health Status List</a>" --bodyContentType HTML --saveToSentItems false

        Write-Host "Outage is Reported for Service : $($workload.WorkloadDisplayName). Please access $webURL/Lists/$listName for more information"
        $updateSinceLastExecution = $true
    }
}
if($updateSinceLastExecution -eq $false){
    Write-Host "NO New Outages are reported yet."
}

#Checking whether any existing outages are resolved
$updateSinceLastExecution = $false
Write-Host "`n### Resolved Outages ###"
Foreach ($Service in $currentOutageServices){
    if($Service.Workload -notin $workLoads.Workload){

        #Removing the outage information from SharePoint List
        $removedRecord = m365 spo listitem remove --webUrl $webURL --listTitle $listName --id  $Service.Id --confirm

        #Send notification using CLI Commands
        m365 outlook mail send --to $notifyEmail --subject "Outage RESOLVED for $($Service.Title)" --bodyContents "Outage which was reported for the Service : $($Service.Title) is RESOLVED." --bodyContentType HTML --saveToSentItems false

        Write-Host "Outage which was reported for the Service : $($Service.Title) is now RESOLVED."
        $updateSinceLastExecution = $true
    }
}
if($updateSinceLastExecution -eq $false){
    Write-Host "No further updates on the existing outages"
}