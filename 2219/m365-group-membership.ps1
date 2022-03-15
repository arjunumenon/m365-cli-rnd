$URLFilterKeyWord = "SPFX"

#Getting the Communication Sites which has the URL Filter "SPFX"
$siteList = m365 spo site list  --type CommunicationSite  --filter "Url -like '$URLFilterKeyWord'" --output json | ConvertFrom-Json
$TotalSiteCount = $SiteList.Count
$SiteCounter = 1

Foreach ($site in $siteList){
    Write-Host "Processing the site No : $SiteCounter / $TotalSiteCount."
    Write-Host "Site URL - $($site.Url)"
    # Getting only Associated Owner and Member Groups using JMES Query
    $AssociatedGroups = m365 spo web get --webUrl $site.Url --withGroups --query "{MemberGroup: AssociatedMemberGroup, OwnerGroup: AssociatedOwnerGroup}" --output json | ConvertFrom-Json

    # Getting list of members from the Owner Group
    $UserList = m365 spo group user list --webUrl $site.Url --groupId $AssociatedGroups.OwnerGroup.Id --query "value" --output json | ConvertFrom-Json

    Write-Host "Total Users available in the Group, $($AssociatedGroups.OwnerGroup.Title) : "$UserList.Count
    Foreach ($User in $UserList){

        # Single User Adding
        m365 spo group user add --webUrl $site.Url --groupId $AssociatedGroups.MemberGroup.Id --userName "$($User.UserPrincipalName)"
        
        # Removing the user from SharePoint Group
        m365 spo group user remove --webUrl $site.Url --groupId $AssociatedGroups.OwnerGroup.Id --userName "$($User.UserPrincipalName)" --confirm
    }
    $SiteCounter++
}