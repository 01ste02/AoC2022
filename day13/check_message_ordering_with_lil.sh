#!/bin/bash

######################## List in List for bash - by Me #######################


declare -A base
declare -A elements


function add () {
        local baseLevel=$1
        local element=$2

        key="$(echo "$RANDOM" | md5sum | head -c32)"
        elements["$key"]="$element"
        base["$baseLevel"]+="$key "
        #echo "Added key: $key" >&2
}

function getArray () {
        local baseLevel=$1
        local index=$2

        keys="${base[$baseLevel]}"
        element="${elements[$key]}"

        #echo "Keys: $keys" >&2
        IFS=" " read -ra keyArray <<< "$keys"
        #echo "Key: ${keyArray[$index]}" >&2
        key="${keyArray[$index]}"

        echo "${elements[$key]}"
}

function getBaseLength {
        echo "${#base[@]}"
}

function getLength () {
        local baseLevel=$1

        keys="${base[$baseLevel]}"
        IFS=" " read -ra keyArray <<< "$keys"
        echo "${#keyArray[@]}"
}

function clearArray {
	unset $base
	unset $elements
	declare -A base
	declare -A elements
}

############################################################################

if [ "$#" -gt 0 ]; then
    printf '%s\n' "$@"
fi


switch=0
left=""
right=""
while IFS= read -r string; do
	if [[ -z "$string" ]]; then 
		#New group
		echo "TODO"
	else
		index=0
		for char in $(sed -e 's/\(.\)/\1\n/g' <<< "$string"); do
			echo "$char"
		done	
	fi
done
