defaultIFS=$IFS
IFS=$'\n'

availableTeams=$(m365 tenant status list --query "value[?Status != 'ServiceOperational']"  --output json)

echo $availableTeams