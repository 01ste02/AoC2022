#!/bin/bash
stack=()
declare -A stack_columns
cols=""

if [ "$#" -gt 0 ]; then
    printf '%s\n' "$@"
fi
while IFS= read -r string; do
    if [[ "$string" == *"["* ]]; then
        #We are still in stack definition
        
	line=""
	while [[ ${#string} -gt 2 ]]; do
	    res="${string:0:4}"
            string="${string:4}"

	    if [[ "$res" == "   "* ]]; then
                line+="[_] "
	    else
	        line+="$res"
	    fi
	done
        
	echo "$line"
	stack+=( "$line" )
    elif [[ "$string" == *"move"* ]]; then
        #We are on move instructions
        echo "Move instructions"
	num="$(sed -E 's/move ([[:digit:]]*) from .*/\1/g' <<< $string)"
        fcol="$(sed -E 's/.* from ([[:digit:]]*) to .*/\1/g' <<< $string)"
	tcol="$(sed -E 's/.* to ([[:digit:]]*).*/\1/g' <<< $string)"
	echo "Number of boxes to move: $num"
	echo "From col: $fcol"
	echo "To col: $tcol"
        
	numChars=$((4*$num))
    	while [[ "${stack_columns[$fcol]:0:4}" == "[_]"* ]]; do
	    stack_columns[$fcol]="${stack_columns[$fcol]:4}"
        done
        crate="${stack_columns[$fcol]:0:$(($numChars-1))}"

        echo "      Crate: $crate"
        echo "      From column: ${stack_columns[$fcol]}"
        echo "      To column: ${stack_columns[$tcol]}"


        stack_columns[$fcol]="${stack_columns[$fcol]:$numChars}"

	while [[ "${stack_columns[$tcol]:0:4}" == "[_]"* ]]; do
            stack_columns[$tcol]="${stack_columns[$tcol]:4}"
        done
            
	stack_columns[$tcol]="$crate ${stack_columns[$tcol]}"
	echo "		Result to: ${stack_columns[$tcol]}"     
	echo "		Result from: ${stack_columns[$fcol]}"
	echo "MOVE DONE"
    elif [ ! -z "$string" ]; then
        #We are on the column definition row
	stack_columns[0]=0
	cols="$string"
	for col in $string; do
	    echo "$col"
	    for row in "${stack[@]}"; do
                echo "Row: $row"
                IFS=" " read -ra elem <<< "${row}"
		#echo "Element $col: ${elem[1]} ${elem[$(($col-1))]}"
		stack_columns[$col]+="${elem[$(($col-1))]} "
            done
	done
	echo "Column 9: ${stack_columns[8]}"
    else
        #Strange empty row..
	echo "Empty row in input"
    fi
done


topString=""
for i in $(rev <<< $cols); do
    echo "${stack_columns[$i]}"
    for item in ${stack_columns[$i]}; do
        if [[ ! "$item" == "[_]" ]]; then
	    topString+="$(sed 's/\[\(.*\)\]/\1/g' <<< $item)"
	    break
	fi
    done
done

topString="$(rev <<< $topString)"
echo "$topString"
