$siteUrl = "https://aum365.sharepoint.com/sites/M365CLI/"
$pageName = "CLI-Webpart-Testing.aspx"

$webPartPropsJson = '{"id":"c70391ea-0b10-4ee9-b2b4-006d3fcad0cd","instanceId":"0683c254-92c4-4a96-adad-dd9fab9a61e0","title":"Quick links","description":"Show a collection of links to content such as documents, images, videos, and more in a variety of layouts with options for icons, images, and audience targeting.","audiences":[],"serverProcessedContent":{"htmlStrings":{},"searchablePlainTexts":{"items[0].title":"Google"},"imageSources":{},"links":{"baseUrl":"https://ajayguptavf.sharepoint.com/sites/mdrndev-comm","items[0].sourceItem.url":"https://google.com"},"componentDependencies":{"layoutComponentId":"706e33c8-af37-4e7b-9d22-6e5694d92a6f"}}}'
# $webPartPropsJson = (Get-Content .\webpartdata.json | Out-String)
# Write-Host $webPartPropsJson

# return
# Make sure to add the backticks, double the JSON double-quotes and escape double quotes in properties'values
# $webPartPropsJson = '`"{0}"`' -f $webPartPropsJson.Replace('\','\\').Replace('"', '""')
$webPartPropsJson = '"{0}"' -f $webPartPropsJson.Replace('\','\\').Replace('"', '""')
# $webPartPropsJson = $webPartPropsJson.Replace('\','\\').Replace('"', '""')


# m365 spo page clientsidewebpart add --webUrl $siteUrl --pageName $pageName --standardWebPart BingMap --webPartProperties '"{""Title"":""Foo location""}"'

m365  spo page clientsidewebpart add --webUrl $siteUrl --pageName $pageName --standardWebPart QuickLinks --webPartData $webPartPropsJson

# m365 spo page control list --webUrl $siteUrl --name $pageName --output json