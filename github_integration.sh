#!/bin/bash

###########################################
# Author : Ravi Kiran
# Version: v1
#
#
# Script Purpose: To communicate and retrieve information from GitHub
# How to Use:
#     Provide your github token and rest API to the script as input. example: ./script.sh $password /org/org-name/repo will give list of all repos inside the organization/team "org-name"
# Took the help of: Abhishek Veeramalla - https://github.com/devops-by-examples/Shell/blob/main/github-api-integration-module.sh
###########################################

# making 2 arguments - password and rest API inputs to script mandatory-

if [ ${#@} -lt 2 ]; then
	echo "usage: $0 [your github token/password] [REST expression]"
	exit 1
fi

GITHUB_TOKEN=$1
GITHUB_API_REST=$2

GITHUB_API_HEADER_ACCEPT="Accept: application/vnd.github.v3+json"

# bootstrapping the script

temp='basename $0'

TMPFILE='mktemp /tmp/${temp}.XXXXXX' || exit 1

function rest_call {
	curl -s $1 -H "${GITHUB_API_HEADER_ACCEPT}" -H "Authorization: token $GITHUB_TOKEN" >> $TMPFILE
}


# single page result-s (no pagination), have no Link: section, the grep result is empty

last_page=`curl -s -I "https://api.github.com${GITHUB_API_REST}" -H "${GITHUB_API_HEADER_ACCEPT}" -H "Authorization: token $GITHUB_TOKEN" | grep '^Link:' | sed -e 's/^Link:.*page=//g' -e 's/>.*$//g'`

# does this result use pagination?
if [ -z "$last_page" ]; then
    # no - this result has only one page
    rest_call "https://api.github.com${GITHUB_API_REST}"
else

    # yes - this result is on multiple pages
    for p in `seq 1 $last_page`; do
       rest_call "https://api.github.com${GITHUB_API_REST}?page=$p"
    done
fi

cat $TMPFILE