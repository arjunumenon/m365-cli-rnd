$siteFilterKeyword = "Central"

#Getting the Communication Sites whose title contains the keyword "SPFX"
$siteList = m365 spo site list --type CommunicationSite --output json --query "[? contains(Title,'$siteFilterKeyword')]" | ConvertFrom-Json
$TotalSiteCount = $SiteList.Count
Write-Host "Total number sites which has the keyword '$siteFilterKeyword' in their title are : $TotalSiteCount"
$SiteCounter = 1

Foreach ($site in $siteList){
    Write-Host "Processing site No : $SiteCounter / $TotalSiteCount."
    Write-Host "Site URL - $($site.Url)"
    # Getting only Associated Owner and Member Groups using JMES Query
    $AssociatedGroups = m365 spo web get --webUrl $site.Url --withGroups --query "{MemberGroup: AssociatedMemberGroup, OwnerGroup: AssociatedOwnerGroup}" --output json | ConvertFrom-Json

    # Getting list of members from the Owner Group
    $UserList = m365 spo group user list --webUrl $site.Url --groupId $AssociatedGroups.OwnerGroup.Id --query "value" --output json | ConvertFrom-Json

    Write-Host "Total Users available in the Group, $($AssociatedGroups.OwnerGroup.Title) : "$UserList.Count
    Foreach ($User in $UserList){

        # Adding the user to Member Group
        m365 spo group user add --webUrl $site.Url --groupId $AssociatedGroups.MemberGroup.Id --userName "$($User.UserPrincipalName)"
        
        # Removing the user from Owner Group
        m365 spo group user remove --webUrl $site.Url --groupId $AssociatedGroups.OwnerGroup.Id --userName "$($User.UserPrincipalName)" --confirm
    }
    $SiteCounter++
}