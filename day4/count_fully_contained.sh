#!/bin/bash
num_fully_contained=0
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
    fully_contained=1
    for val in ${range1[@]}; do
	found=0
	for ind in ${range2[@]}; do
	    echo "	Testing: $val $ind"
	    if [[ "$val" == "$ind" ]]; then
                found=1
		echo "		$val found in Range 2 as $ind"
		break
	    fi
	done

	if [[ "$found" == "0" ]]; then
	    fully_contained=0
	    echo "	Range 2 does not contain $val"
	fi
    done
    
    if [[ "$fully_contained" == 1 ]]; then
        num_fully_contained=$(("$num_fully_contained"+1))
        echo "  Range 1 was fully contained in Range 2"
    else
        echo "Testing if range 2 is fully contained in range 2"
        fully_contained=1
        for val in ${range2[@]}; do
            found=0
            for ind in ${range1[@]}; do
                echo "      Testing: $val $ind"
                if [[ "$val" == "$ind" ]]; then
                    found=1
                    echo "          $val found in Range 1 as $ind"
                    break
                fi
            done

            if [[ "$found" == "0" ]]; then
                fully_contained=0
                echo "      Range 1 does not contain $val"
            fi
        done

        if [[ "$fully_contained" == 1 ]]; then
            num_fully_contained=$(("$num_fully_contained"+1))
            echo "	Range 2 was fully contained in Range 1"
        fi
    fi

done

echo $num_fully_contained
