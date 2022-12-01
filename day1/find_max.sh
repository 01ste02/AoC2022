#!/bin/bash
elves=()
elf=0
if [ "$#" -gt 0 ]; then
    # We have command line arguments.
    # Output them with newlines in-between.
    printf '%s\n' "$@"
#else
    # No command line arguments.
    # Just pass stdin on.
    #cat
fi #|
while IFS= read -r string; do
    if [ -z "$string"  ]; then
	elves+=( "$elf" )
	elf=0
    else
	elf=$(($elf+"$string"))
    fi
done

elves+=( "$elf" )
elf=0

printf "Elves: \n"
for el in ${elves[@]}; do
    printf "$el \n"
done


printf "Sorted elves: \n"
IFS=$'\n' sorted=($(sort -n -r <<<"${elves[*]}"))
unset IFS

for el in ${sorted[@]}; do
    printf "$el \n"
done

printf "Top elf: $(echo ${sorted[0]}) \n"
printf "Top three elves: $(echo $((${sorted[0]}+${sorted[1]}+${sorted[2]})))\n"
