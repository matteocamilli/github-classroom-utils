#!/bin/bash

# ########################################################
# Add a member to team <TEAM_ID>
# Parameters: Github <user> to add
# ########################################################

. config

[ $# -ge 1 -a -f "$1" ] && input=$(cat $1) || input=$(cat -)

for user in $input; do
	curl -u matteocamilli:$GITHUB_API_TOKEN https://api.github.com/teams/$TEAM_ID/members/$user -X PUT -d ""
done
