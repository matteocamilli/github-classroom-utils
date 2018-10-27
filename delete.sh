#!/bin/bash

# ##################################################
# Delete the student repos of the given assignment
# Parameters: Github <user> and <assignment> name

  user=$1
  assignment=$2

# ##################################################

. config

last_page=$(curl -i -u $user:$GITHUB_API_TOKEN https://api.github.com/orgs/$ORGANIZATION_NAME/repos 2>/dev/null | grep last | cut -d'=' -f4 | cut -d'>' -f1)

for page in $(seq 1 $last_page)
do
	reply=$(curl -u $user:$GITHUB_API_TOKEN https://api.github.com/orgs/$ORGANIZATION_NAME/repos?page=$page 2>/dev/null)
	repos=$(echo $reply | jq '.[] | select(.name | startswith("'$assignment'")) | {B: .name}' | egrep -v "\{|\}" | sed -e 's/"B"://' | tr -d '"')
  for repo_name in $repos
  do
    echo deleting $repo_name ...
    curl -u matteocamilli:$GITHUB_API_TOKEN https://api.github.com/repos/$ORGANIZATION_NAME/$repo_name -X DELETE -d ""
  done
done
