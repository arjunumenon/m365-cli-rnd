#Using the Office365CLI to list all Teams apps in all Microsoft Teams teams of your tenant

if(o365 status -contains 'connectedAs')
{
    Write-Host 'Logged in'
}
else {
    write-Host 'NOT CONNECTED'
}

o365 login -t password -u "arjun@a-um.me" -p "P@ssw0rd4aum"

$availableTeams = o365 teams team list -o json | ConvertFrom-Json

if($availableTeams.count -gt 15)
{
    $duration =  [math]::Round(($availableTeams.count/60),1);
    Write-Host "Start iterating through" $availableTeams.count "teams. This probably will take around" $duration" minutes to finish."
}

foreach ($team in $availableTeams) {

    $apps = o365 teams app list -i $team.Id -a    
    Write-Output "All apps in team: " $team.displayName " " $team.id
    Write-Output $apps
}