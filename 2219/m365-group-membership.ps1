# $SiteList = m365 spo site list

# Write-Host $SiteList

#m365 spo site list --output json --query "[]"
#m365 spo site list --output json --query "[?Title == 'DEV-IceBreaker']"
m365 spo site list --output json --query "[? contains(Title,'DEV')]"
