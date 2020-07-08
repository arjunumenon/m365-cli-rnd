defaultIFS=$IFS
IFS=$'\n'

availableTeams=$(o365 teams team list -o json)

if [[ $(echo $availableTeams | jq length) -gt 15 ]]; 
then
  #Calculating Approximate duration. Assuming 1 minute per team
  duration=$(((($(echo $availableTeams | jq length)) + 59) / 60))
  echo "Start iterating through" $(echo $availableTeams | jq length) "teams. This probably will take around" $duration" minutes to finish."
else
  echo "There are total of" $(echo $availableTeams | jq length) "teams available"
fi

for team in $(echo $availableTeams | jq -c '.[]'); do
    apps=$(o365 teams app list -i $(echo $team | jq ''.id) -a)
    echo "All apps in team are given below: " $(echo $team | jq ''.displayName) " " $(echo $team | jq ''.id)
    echo $apps    
done