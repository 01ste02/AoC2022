#!/bin/bash
if [ "$#" -gt 0 ]; then
    printf '%s\n' "$@"
fi
starts=""
while IFS= read -r string; do
    if [[ ! -z "$string"  && "${#string}" -gt 14 ]]; then
        # Row is not empty
	echo "Processing: $string"
	lower=0
        upper=13
	itr="$lower"
	echo "ITR $itr"
	while [[ "$upper" -lt "${#string}" ]]; do 
	    found=0
	    while [[ ! $itr -eq $upper ]]; do
		for m in $(seq $(($itr+1)) $upper); do
		    echo "	Comparing $itr to $m: ${string:$itr:1} to ${string:$m:1}"
		    if [[ "${string:$itr:1}" == "${string:$m:1}"  ]]; then
                        echo "Found equal chars - start of string not here, increasing interval"
			found=1
			break
                    fi 
		done
		if [[ "$found" == "1" ]]; then
		    echo "Found $found"
		    break
		fi
		itr=$(($itr+1))
	    done
            
            if [[ "$found" == "0" ]]; then
		echo "Start of packet found at $(($upper+1))"
		starts+="$(($upper+1))"
                break
            fi
	     
            lower=$(($lower+1))
            upper=$(($upper+1))
	    itr="$lower"
	    echo "Lower: $lower Upper: $upper ITR: $itr"
        done

    fi
done

echo "$starts"
