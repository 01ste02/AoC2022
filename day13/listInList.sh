#!/bin/bash

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

echo "Length of base $(getBaseLength)"
add 0 "Testing"
echo "Added element"
echo "Length of base $(getBaseLength)"
echo "Length of index 0 of base: $(getLength 0)"
add 0 "Testing22222"
echo "Added element"
echo "Length of base $(getBaseLength)"
echo "Length of index 0 of base: $(getLength 0)"
add 1 "Testing33333333333333"
echo "Added element"
echo "Length of base $(getBaseLength)"
echo "Length of index 1 of base: $(getLength 1)"
echo "Length of index 2 of base: $(getLength 2)"
echo "Array on index 0 0: $(getArray 0 0)"
echo "Array on index 0 1: $(getArray 0 1)"


for i in $(seq 1 100); do
	add 0 "$i"
done

echo "	Added lots of stuff - length $(getLength 0)"
for i in $(seq 0 $(($(getLength 0)-1))); do
	echo "	Same: $(getArray 0 $i)"
done


for i in $(seq 1 100); do
	add $i "$(($i*$i))"
done

echo "  Added lots of stuff on random indexes"
for i in $(seq 0 $(($(getBaseLength)-1))); do
	echo "  Random: $(getArray $i $(($(getLength $i)-1)))"
done
