# Small script that iterates through all Microsoft Teams teams
# and counts the usage of Teams apps using the Office365CLI

& .\get-Connection.ps1

$availableTeams = o365 teams team list -o json | ConvertFrom-Json

if($availableTeams.count -gt 15)
{
    $duration =  [math]::Round(($availableTeams.count/60),1);
    Write-Host "Start iterating through" $availableTeams.count "teams. This probably will take around" $duration" minutes to finish."
}

$appcounts = @{ }
foreach ($team in $availableTeams) {

    $apps = o365 teams app list -i $team.id -a -o json
    Write-Host "Counting apps in team: " $team.displayName " " $team.id
    $appsJson = $apps | ConvertFrom-Json

    $appsJson | foreach {
        if ($appcounts.ContainsKey($_.teamsApp.displayName)) {
            $appcounts[$_.teamsApp.displayName] = [Int32]$appcounts[$_.teamsApp.displayName] + 1    
        }
        else {
            $appcounts.Add($_.teamsApp.displayName, [Int32]"1") 
        }
    }
        
}

foreach ($h in $appcounts.GetEnumerator() | Sort-Object -Property value) {
    Write-Output "$($h.Name): $($h.Value)"
}