#!/bin/bash

# ########################################################
# List the students foreach repo of the given assignment
# Parameters: Github <user> and <assignment> name
  
  user=$1
  assignment=$2
  
# ########################################################

. config

repo_data() {
	url=$1
	reply=$(curl -u $user:$GITHUB_API_TOKEN $url 2>/dev/null)
	echo $(echo $reply | jq '.[] | select(.name | startswith("'$assignment'")) | {A: .id, B: .name}' | egrep -v "\{|\}" | sed -e 's/"A"://' | sed -e 's/"B"://' | sed 'N;s/\n/ /' | tr -d '"' | tr -d ',')
}

collaborators_data() {
	url=$1
	reply=$(curl -u $user:$GITHUB_API_TOKEN $url 2>/dev/null)
	echo $(echo $reply | jq '.[] | {A: .url}' | egrep -v "\{|\}" | sed -e 's/"A"://' | tr -d '"')
}

user_data() {
	url=$1
	reply=$(curl -u $user:$GITHUB_API_TOKEN $url 2>/dev/null)
	echo $(echo $reply | jq '{A: .login, B: .name}' | egrep -v "\{|\}" | sed -e 's/"A"://' | sed -e 's/"B"://' | tr -d '"')
}


repo_data https://api.github.com/orgs/$ORGANIZATION_NAME/repos | while read -r line
do
	repo_id=$(echo $line | cut -d' ' -f1)
	repo_name=$(echo $line | cut -d' ' -f2)
	info="$repo_id, $repo_name"
	for user_url in $(collaborators_data https://api.github.com/repos/$ORGANIZATION_NAME/$repo_name/collaborators)
	do
		info="$info, $(user_data $user_url)"
	done
	echo $info
done