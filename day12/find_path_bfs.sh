#!/bin/bash
if [ "$#" -gt 0 ]; then
    printf '%s\n' "$@"
fi

declare -A map
declare -A visited

row=0
startX=0
startY=0
while IFS= read -r string; do
    map[$row]=$string
    row=$(($row+1))
    if [[ "$string" == *"S"* ]]; then
        rest=${string#*"S"}
        startX=$(( ${#string} - ${#rest} - 1 ))
        startY=$(($row-1))
    fi
done

numSpots=$(($row*${#map[0]}))
echo "Starting point: $startX $startY numSpots: $numSpots"

for x in $(seq 0 $((${#map[0]}-1))); do # Mark all as not visited
	for y in $(seq 0 $(($row-1))); do
		visited["$x,$y"]=0
	done
done



function getKeyCode () {
    local X=$1
    local Y=$2
    char="${map[$Y]:$X:1}"
    if [[ "$char" == "E" ]]; then
        echo $(printf %d "'z")
    else
        echo $(printf %d "'${map[$Y]:$X:1}")
    fi
}

function findPossiblePaths () {
    local X=$1
    local Y=$2

    possibilities=""
    for x in $(seq $(($X-1)) $(($X+1))); do
        for y in $(seq $(($Y-1)) $(($Y+1))); do
            #echo "     Checking $x $y" >&2
            if ! [[ $X -eq $x && $Y -eq $y ]] && [[ $x -ge 0 && $x -lt ${#map[0]} && $y -ge 0 && $y -lt $row ]] && [[ $x -eq $X || $y -eq $Y ]] ; then
                current=$(getKeyCode $X $Y)
                next=$(getKeyCode $x $y)
                #echo "         $x $y passed the coord check, onto keycode $current $next" >&2
                if [[ "$current $(($current+1))" ==  *"$next"* ]] || [[ $next -lt $current && ! $next -eq 83 ]] || [[ $current -eq 83 ]]; then
                    #echo "             $x $y was valid" >&2
                    possibilities="$x,$y $possibilities"
                fi
            fi
        done
    done
    echo $possibilities >&2
    echo $possibilities
}




visited["$startX,$startY"]=1

queue=( )


declare -A parents

target=""
queue+=("$startX,$startY")
while [ ${#queue[@]} -gt 0 ]; do
	elem=${queue[0]}
	queue=("${queue[@]:1}")

	IFS="," read -ra coords <<< $elem
	echo "Elem: $elem Pos: ${map[${coords[1]}]:${coords[0]}:1}"
	if [[ "${map[${coords[1]}]:${coords[0]}:1}" == "E" ]]; then
	    echo "FOUND IT! $elem"
	    target=$elem
	fi

	for coord in $(findPossiblePaths ${coords[0]} ${coords[1]}); do
        	IFS="," read -ra xy <<< $coord
		if [[ ${visited["${xy[0]},${xy[1]}"]} -eq 0 ]]; then
			queue+=("${xy[0]},${xy[1]}")
			visited["${xy[0]},${xy[1]}"]=1
			parents["${xy[0]},${xy[1]}"]="${coords[0]},${coords[1]}"
		fi
        done

done

par=$target
steps=1
while [[ 1 -eq 1 ]]; do
	IFS="," read -ra coords <<< $par
	parent=${parents[$par]}
	echo "par: $par Parent: $parent"
	if [[ "$parent" == "$startX,$startY" ]]; then
		echo "Steps to find: $steps"
		exit
	fi
	par=$parent
	steps=$(($steps+1))
done
