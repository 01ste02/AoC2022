#!/bin/bash
num_overlapping=0
if [ "$#" -gt 0 ]; then
    printf '%s\n' "$@"
fi
while IFS= read -r pair; do
    IFS="," read -ra ranges <<< "$pair"
    echo "First ${ranges[0]} second ${ranges[1]}"

    IFS="-" read -ra limits_elf_1 <<< "${ranges[0]}"
    IFS="-" read -ra limits_elf_2 <<< "${ranges[1]}"

    range1=()
    range2=()
    
    
    for i in $(seq ${limits_elf_1[0]} ${limits_elf_1[1]}); do
        range1+=( "$i" )
    done

    for i in $(seq ${limits_elf_2[0]} ${limits_elf_2[1]}); do
        range2+=( "$i" )
    done

    printf "Elf 1: "
    printf '%s, ' "${range1[@]}"
    printf "\n"

    printf "Elf 2: "
    printf '%s, ' "${range2[@]}"
    printf "\n"

    echo "Testing if range 1 is fully contained in range 2"
    overlapping=0
    for val in ${range1[@]}; do
	for ind in ${range2[@]}; do
	    echo "	Testing: $val $ind"
	    if [[ "$val" == "$ind" ]]; then
                overlapping=1
		echo "		$val found in Range 2 as $ind"
		break
	    fi
	done

	if [[ "$overlapping" == "1" ]]; then
	    num_overlapping=$(("$num_overlapping"+1))
	    echo "	Overlap found"
	    break
	fi
    done
    
done

echo $num_overlapping
