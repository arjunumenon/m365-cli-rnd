# $SiteList = m365 spo site list

# Write-Host $SiteList

#m365 spo site list --query "[]"
#m365 spo site list --output json --query "[]"
#m365 spo site list --output json --query "[?Title == 'DEV-IceBreaker']"
#m365 spo site list --output json --query "[? contains(Title,'m365')]"

$siteFilterKeyword = "SPFX"
#m365 spo site list --output json --query "[? contains(Title,'$siteFilterKeyword')]"

# $siteList = m365 spo site list --output json --query "[? contains(Title,'$siteFilterKeyword')]" | ConvertFrom-Json
$siteList = m365 spo site list  --type CommunicationSite  --filter "Url -like '$siteFilterKeyword'" --output json | ConvertFrom-Json
$TotalSiteCount = $SiteList.Count
$SiteCounter = 1

Foreach ($site in $siteList){
    Write-Host "Processing the site No : $SiteCounter / $TotalSiteCount."
    Write-Host "Site URL - $($site.Url)"
    # Getting only Associated Owner and Member Groups using JMES Query
    $AssociatedGroups = m365 spo web get --webUrl $site.Url --withGroups --query "{MemberGroup: AssociatedMemberGroup, OwnerGroup: AssociatedOwnerGroup}" --output json | ConvertFrom-Json

    # Getting list of members from the Group
    # Conventional Approach
    $UserList = m365 spo group user list --webUrl $site.Url --groupId $AssociatedGroups.OwnerGroup.Id --query "value" --output json | ConvertFrom-Json

    Write-Host "Total Users available in the Group : "$UserList.Count
    $UserlistToBeAdded =  [System.Collections.ArrayList]@()
    Foreach ($User in $UserList){
        # Add Users to Member Group
        write-Host "Adding User $($User.UserPrincipalName) to the Group $($AssociatedGroups.MemberGroup.Id)"
        
        # Single User Adding
        m365 spo group user add --webUrl $site.Url --groupId $AssociatedGroups.MemberGroup.Id --userName "$($User.UserPrincipalName)"
        
        # # Adding to Arraylist and adding command will be executed later since it supports multiple - 
        # # user addition in single command call
        # $UserlistToBeAdded+=$User.UserPrincipalName
        
        # Removing the user from SharePoint Group
        m365 spo group user remove --webUrl $site.Url --groupId $AssociatedGroups.OwnerGroup.Id --userName "$($User.UserPrincipalName)" --confirm
    }

    # Write-Host ($UserlistToBeAdded -join ", ")
    # m365 spo group user add --webUrl $site.Url --groupId $AssociatedGroups.MemberGroup.Id --userName "$UserlistToBeAdded" --debug
    $SiteCounter++
}