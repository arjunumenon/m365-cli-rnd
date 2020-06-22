#Using the Office365CLI to list all Teams apps in all Microsoft Teams teams of your tenant

$Status = o365 status

if($Status -like 'connectedAs*')
{
    Write-Host 'YEP - ' $Status
    o365 logout
}
else {
    write-Host 'NO - ' $Status
    o365 login -t password -u "arjun@a-um.me" -p "P@ssw0rd4aum"
}