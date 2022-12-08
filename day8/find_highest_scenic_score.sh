#!/bin/bash

if [ "$#" -gt 0 ]; then
    printf '%s\n' "$@"
fi

declare -A forest

# Read number of trees
row=0
while IFS= read -r string; do
    row=$(($row+1)) # Row numbers start at 1
    forest[$row]=$string
    echo $string
done


i=2
j=1

scores=()

while [[ $i -le $(($row-1)) ]]; do
    while [[ $j -le $((${#forest[$i]}-2)) ]]; do
        elem=${forest[$i]:$j:1}
	echo "NEW ELEMENT $elem ROW $i OF $row"
	left=${forest[$i]:0:$j}
        

        visibleLeft=0
        while read char; do #Check how many trees are visible
            if [[ $char -lt $elem ]]; then
		visibleLeft=$(($visibleLeft+1))
	    elif [[ $char -ge $elem ]]; then # Found stop
		visibleLeft=$(($visibleLeft+1))
	        break
            fi
        done <<< $(echo $left | rev | sed 's/\(.\)/\1\n/g')	

	right=${forest[$i]:$(($j+1))}

        visibleRight=0
        while read char; do #Check how many trees are visible
            if [[ $char -lt $elem ]]; then
                visibleRight=$(($visibleRight+1))
	    elif [[ $char -ge $elem ]]; then # Found stop
                visibleRight=$(($visibleRight+1))
                break
            fi
        done <<< $(echo $right | sed 's/\(.\)/\1\n/g') #Do not reverse, string already in correct order

	top=""

	for r in $(seq 1 $(($i-1))); do
	    top+="${forest[$r]:$j:1}"
	done
        
        visibleTop=0
        while read char; do #Check how many trees are visible
            if [[ $char -lt $elem ]]; then
                visibleTop=$(($visibleTop+1))
	    elif [[ $char -ge $elem ]]; then # Found stop
                visibleTop=$(($visibleTop+1))
                break
            fi
        done <<< $(echo $top | rev | sed 's/\(.\)/\1\n/g')

        bottom=""
        
	for r in $(seq $(($i+1)) $row); do
	    bottom+="${forest[$r]:$j:1}"
        done
        
	visibleBottom=0
        while read char; do #Check how many trees are visible
            if [[ $char -lt $elem ]]; then
                visibleBottom=$(($visibleBottom+1))
	    elif [[ $char -ge $elem ]]; then # Found stop
                visibleBottom=$(($visibleBottom+1))
                break
            fi
        done <<< $(echo $bottom | sed 's/\(.\)/\1\n/g') #Do not reverse since string is already in correct order

 	#echo "	Row ${forest[$i]} to the left of our element $elem is $left and to the right we have $right"
	#echo "	Above we have $top and below we have $bottom"

	score=$(($visibleLeft*$visibleRight*$visibleTop*$visibleBottom))

	#echo "	Score: $score Left: $visibleLeft Right $visibleRight Top: $visibleTop Bottom: $visibleBottom"

        scores+=( "$score" )
	j=$(($j+1))
    done
    j=1
    i=$(($i+1))
done

IFS=$'\n' sortedScores=($(sort -n -r <<<"${scores[*]}"))

echo "Top score: ${sortedScores[0]}"
