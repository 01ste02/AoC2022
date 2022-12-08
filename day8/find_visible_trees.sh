#!/bin/bash

if [ "$#" -gt 0 ]; then
    printf '%s\n' "$@"
fi

declare -A forest

function checkVisible () {
    visible=1
    while read char; do #Check if tree is visible
        if [[ $char -ge $2 ]]; then
            visible=0
            break
        fi
    done <<< $(echo $1 | sed 's/\(.\)/\1\n/g')
    echo $visible
}

# Read number of trees
row=0
while IFS= read -r string; do
    row=$(($row+1)) # Row numbers start at 1
    forest[$row]=$string
    echo $string
done


numVisibleTrees=$(($row+$row+${#forest[1]}+${#forest[1]}-4)) # Add the number of rows twice (left and right edge) and the length of the rows twice (top and bottom) and subtract 4 because of shared corners
i=2
j=1

while [[ $i -le $(($row-1)) ]]; do
    while [[ $j -le $((${#forest[$i]}-2)) ]]; do
        elem=${forest[$i]:$j:1}
	echo "NEW ELEMENT $elem ROW $i OF $row"
	left=${forest[$i]:0:$j}
        
	if [[ $(checkVisible $left $elem) -eq 1 ]]; then
	    #echo "	Tree was visible from the left"
	    numVisibleTrees=$(($numVisibleTrees+1))
	    #echo "Visible: $numVisibleTrees"
	    j=$(($j+1))
	    continue
	fi

	#echo "	Tree was not visible from the left"

	right=${forest[$i]:$(($j+1))}

	if [[ $(checkVisible $right $elem) -eq 1 ]]; then
	    #echo "	Tree was visible from the right"
            numVisibleTrees=$(($numVisibleTrees+1))
	    #echo "Visible: $numVisibleTrees"
	    j=$(($j+1))
            continue
        fi

	#echo "	Tree was not visible from the right"

	top=""

	visible=1
	for r in $(seq 1 $(($i-1))); do
	    top+="${forest[$r]:$j:1}"
	    #echo "TOP=$top"
	    if [[ ${forest[$r]:$j:1} -ge $elem ]]; then
                #echo "	Tree was not visible from the top"
		visible=0
		break
	    fi
	done

	if [[ $visible -eq 1 ]]; then
            #echo "	Tree was visible from the top"
	    numVisibleTrees=$(($numVisibleTrees+1))
	    #echo "Visible: $numVisibleTrees"
	    j=$(($j+1))
	    continue
	fi

        bottom=""

	visible=1
	for r in $(seq $(($i+1)) $row); do
	    bottom+="${forest[$r]:$j:1}"
	    #echo "BOTTOM=$bottom"
            if [[ ${forest[$r]:$j:1} -ge $elem ]]; then
                #echo "  	Tree was not visible from the bottom"
                visible=0
		break
            fi
        done

        if [[ $visible -eq 1 ]]; then
            #echo "      Tree was visible from the bottom"
            numVisibleTrees=$(($numVisibleTrees+1))
	    j=$(($j+1))
            continue
        fi

        #echo "	Tree was not visible at all"
 	#echo "	Row ${forest[$i]} to the left of our element $elem is $left and to the right we have $right"
	#echo "	Above we have $top and below we have $bottom"


	j=$(($j+1))
	#echo "Visible: $numVisibleTrees"
    done
    j=1
    i=$(($i+1))
done


echo "Num visible trees: $numVisibleTrees"
