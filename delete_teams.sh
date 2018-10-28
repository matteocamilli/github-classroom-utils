#!/bin/bash

# ##################################################
# Delete the student teams in a given year
# Parameters: Github <user> and contained <year>

  user=$1
  year=$2

# ##################################################

. config

exclusion="students_aa2017-18"

last_page=$(curl -i -u $user:$GITHUB_API_TOKEN https://api.github.com/orgs/$ORGANIZATION_NAME/teams 2>/dev/null | grep last | cut -d'=' -f4 | cut -d'>' -f1)

for page in $(seq 1 $last_page)
do
  reply=$(curl -u $user:$GITHUB_API_TOKEN https://api.github.com/orgs/$ORGANIZATION_NAME/teams?page=$page 2>/dev/null)
	teams=$(echo $reply | jq '.[] | {B: .id}' | egrep -v "\{|\}" | sed -e 's/"B"://' | tr -d '"')
  for team_id in $teams
  do
    team=$(curl -u $user:$GITHUB_API_TOKEN https://api.github.com/teams/$team_id 2>/dev/null)
    date=$(echo $team | jq '.created_at' | tr -d '"')
    name=$(echo $team | jq '.name' | tr -d '"')
    if [[ "$name" != $exclusion && "$date" =~ $year ]]
    then
      echo deleting team $name id $team_id created at $date ...
      curl -u matteocamilli:$GITHUB_API_TOKEN https://api.github.com/teams/$team_id -X DELETE -d ""
    fi
  done
done
