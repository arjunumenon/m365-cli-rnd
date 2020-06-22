
#Enable the connection if connection not available

Write-Host 'Testing Connection and Connecting to Tenant if no Connection' -ForegroundColor Yellow

$Status = o365 status

if($Status -like 'connectedAs*')
{
    Write-Host 'Connection Available.. Connection Status - ' $Status
    #o365 logout
}
else 
{
    $Username = 'arjun@a-um.me'
    $Password = 'P@ssw0rd4aum'
    write-Host 'NO Connection Available. Connecting as ' + $Username
    o365 login -t password -u $Username -p $Password
}