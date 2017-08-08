#!/bin/bash

# ##################################################
# List the clone commands for the given assignment
# Parameters: Github <user> and <assignment> name
  
  user=$1
  assignment=$2
  
# ##################################################

. config

reply=$(curl -u $user:$GITHUB_API_TOKEN https://api.github.com/orgs/$ORGANIZATION_NAME/repos 2>/dev/null)
echo $reply | jq '.[] | select(.name | startswith("'$assignment'")) | {A: .ssh_url, B: .id}' | egrep -v "\{|\}" | sed -e 's/"A":/git clone/' | sed -e 's/"B"://' | sed 'N;s/\n/ /' | tr -d '"' | tr -d ','