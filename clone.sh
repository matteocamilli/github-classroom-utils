#!/bin/bash

# ##################################################
# List the clone commands for the given assignment
# Parameters: Github <user> and <assignment> name
  
  user=$1
  assignment=$2
  
# ##################################################

. config

last_page=$(curl -i -u $user:$GITHUB_API_TOKEN https://api.github.com/orgs/$ORGANIZATION_NAME/repos 2>/dev/null | grep last | cut -d'=' -f4 | cut -d'>' -f1)

for page in $(seq 1 $last_page)
do
	reply=$(curl -u $user:$GITHUB_API_TOKEN https://api.github.com/orgs/$ORGANIZATION_NAME/repos?page=$page 2>/dev/null)
	echo $reply | jq '.[] | select(.name | startswith("'$assignment'")) | {A: .ssh_url, B: .name}' | egrep -v "\{|\}" | sed -e 's/"A":/git clone/' | sed -e 's/"B"://' | sed 'N;s/\n/ /' | tr -d '"' | tr -d ','
done