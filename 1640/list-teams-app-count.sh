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

declare -A appListswithCount
unset appListswithCount
for team in $(echo $availableTeams | jq -c '.[]'); do
    apps=$(o365 teams app list -i $(echo $team | jq ''.id) -a -o json)
    echo "Counting apps in team: " $(echo $team | jq ''.displayName) " " $(echo $team | jq ''.id)
    for indivApp in $(echo $apps | jq -c '.[]'); do
        #echo $indivApp
        appDisplayname=$(echo $indivApp | jq '.teamsApp.displayName')
        echo $appDisplayname

        # echo ${#appListswithCount[@]} 
        #Working Version
        if [[ ${!appListswithCount[@]} =~ $appDisplayname ]]; then
            #Already Available
            echo "Available"
            CurrentAppcount=${appListswithCount[$appDisplayname]}
            CurrentAppcount+=1
            ${appListswithCount[$appDisplayname]} = $currentAppcount
        else
          #NOT AVAILABLE
           echo "NOT"
           #$appListswithCount+=([$appDisplayname]="1")
           appListswithCount+=(" ["$appDisplayname"] "="1")
        fi
        
    done   
    #break
done

for i in "${!appListswithCount[@]}"; do
  echo $i
done