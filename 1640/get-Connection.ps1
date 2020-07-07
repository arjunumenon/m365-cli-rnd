
#Enable the connection if connection not available

Write-Host 'Testing Connection and Connecting to Tenant if no Connection' -ForegroundColor Yellow

$Status = o365 status

if($Status -like 'connectedAs*')
{
    Write-Host 'Connection Available.. Connection Status - ' $Status
}
else 
{
    $Username = 'arjun@aum365.onmicrosoft.com'
    $PasswordEncrypted = Read-Host -Prompt 'Type in your Password' -AsSecureString
    $bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($PasswordEncrypted)
    $Password = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr)

    write-Host 'NO Connection Available. Connecting as ' + $Username
    o365 login -t password -u $Username -p $Password
}