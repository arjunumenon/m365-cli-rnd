function  createCustomAADApp{
    param (
        [Parameter(Mandatory = $false)]
        [string]$APIPermissionList,
        [Parameter(Mandatory = $false)]
        [string]$AppManifestJSONFile
    )

        # Checking Login status and initiate login if not logged
        $LoginStatus = m365 status --output text
        if($LoginStatus -eq "Logged out")
        {
            Write-Host "Not logged in. Initiating Login process"
            m365 login
        }

        Write-Host "Creating AAD App"
        # Create custom App with needed permission
        $AddedApp = (m365 aad app add --manifest $AppManifestJSONFile  --redirectUris "https://login.microsoftonline.com/common/oauth2/nativeclient" --platform publicClient --apisDelegated $APIPermissionList --output json) | ConvertFrom-Json

    return $AddedApp
}

function initiateLoginUsingCustomAddin{
    param (
        [Parameter(Mandatory = $true)]
        [string]$CustomAADAppId,
        [Parameter(Mandatory = $false)]
        [string]$AppTenantId = ""
    )

    if($AppTenantId -eq "")
    {
        $LoginStatus = m365 status --output text
        Write-Host $LoginStatus
        if($LoginStatus -eq "Logged out")
        {
            m365 login
        }
        $AppTenantId = m365 tenant id get
    }


    # Checking whether current Login ID is using above custom App ID or not. If not, initiating login
    $LoggedAppId = ((m365 cli doctor --output json) | ConvertFrom-Json).cliAadAppId
    if($CustomAADAppId -ne $LoggedAppId)
    {
        #login using Custom App ID
        Write-Host "Initiating login using Custom Add ID : $CustomAADAppId to Tenant $AppTenantId"
        m365 login --appId $CustomAADAppId --tenant $AppTenantId
    }

}

# Custom App ID where the Graph API Permissions (Chat.Read, Chat.ReadWrite). Update Permission if needed
$APIPermissionList = "https://graph.microsoft.com/User.Read,https://graph.microsoft.com/Chat.Read,https://graph.microsoft.com/Chat.ReadWrite"
$AppManifestJSON = "@custom-app-manifest.json"

$AddedApp = createCustomAADApp -APIPermissionList $APIPermissionList -AppManifestJSONFile $AppManifestJSON
Write-Host "AAD App with the details will be used. App ID : $($AddedApp.appId). Object ID : $($AddedApp.objectId)"
$CustomAADAppId = $AddedApp.appId

# initiateLoginUsingCustomAddin -CustomAADAppId $CustomAADAppId
initiateLoginUsingCustomAddin -CustomAADAppId $CustomAADAppId -AppTenantId "7c9154c9-0f63-443e-a07a-8a3ede021afc"
#Dummy comments please