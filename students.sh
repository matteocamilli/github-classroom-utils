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
	echo $reply | jq '.[] | select(.name | startswith("'$assignment'")) | {A: .name}' | egrep -v "\{|\}" | sed -e 's/"A"://' | tr -d '"' | tr -d ','
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

last_page=$(curl -i -u $user:$GITHUB_API_TOKEN https://api.github.com/orgs/$ORGANIZATION_NAME/repos 2>/dev/null | grep last | cut -d'=' -f4 | cut -d'>' -f1)

for page in $(seq 1 $last_page)
do
	for repo_name in $(repo_data https://api.github.com/orgs/$ORGANIZATION_NAME/repos?page=$page)
	do
		info="$repo_name"
		for user_url in $(collaborators_data https://api.github.com/repos/$ORGANIZATION_NAME/$repo_name/collaborators)
		do
			info="$info, $(user_data $user_url)"
		done
		echo $info
	done
done
