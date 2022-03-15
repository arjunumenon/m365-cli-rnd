# $SiteList = m365 spo site list

# Write-Host $SiteList

#m365 spo site list --query "[]"
#m365 spo site list --output json --query "[]"
#m365 spo site list --output json --query "[?Title == 'DEV-IceBreaker']"
#m365 spo site list --output json --query "[? contains(Title,'m365')]"

$siteFilterKeyword = "Corporate"
#m365 spo site list --output json --query "[? contains(Title,'$siteFilterKeyword')]"


$siteList = m365 spo site list --output json --query "[? contains(Title,'$siteFilterKeyword')]" | ConvertFrom-Json

Foreach ($site in $siteList){
    Write-Host "Processing the site - $($site.Url)"
}