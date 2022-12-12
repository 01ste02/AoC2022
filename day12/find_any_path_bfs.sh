#!/bin/bash
if [ "$#" -gt 0 ]; then
    printf '%s\n' "$@"
fi

declare -A map

row=0
startQueue=( )

while IFS= read -r string; do
    sX=0
    sY=0
    map[$row]=$string
    row=$(($row+1))
    tX=0

    for char in $(echo $string | sed -e 's/\(.\)/\1\n/g'); do
    	if [[ "$char" == "S" || "$char" == "a" ]]; then
		echo "Starting at $tX,$(($row-1))"
		startQueue+=("$tX,$(($row-1))")
	fi
	tX=$(($tX+1))
    done
done


function getKeyCode () {
    local X=$1
    local Y=$2
    char="${map[$Y]:$X:1}"
    if [[ "$char" == "E" ]]; then
        echo $(printf %d "'z")
    elif [[ "$char" == "S" ]]; then
	echo $(printf %d "'a")
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
    #echo $possibilities >&2
    echo $possibilities
}


declare -A visited

declare -A distances

for x in $(seq 0 $((${#map[0]}-1))); do # Mark all as not visited
       	for y in $(seq 0 $(($row-1))); do
               	visited["$x,$y"]=0
       	done
done


queue=( )

for point in ${startQueue[@]}; do
	visited["$point"]=1
	queue+=("$point")
done
declare -A parents

target=""
while [ ${#queue[@]} -gt 0 ]; do
	elem=${queue[0]}
	queue=("${queue[@]:1}")

	IFS="," read -ra coords <<< $elem
	#echo "Elem: $elem Pos: ${map[${coords[1]}]:${coords[0]}:1}"
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
#echo "			TARGET: $target"
steps=1
while [[ 1 -eq 1 ]]; do
	IFS="," read -ra coords <<< $par
	parent=${parents[$par]}
	#echo "			par: $par Parent: $parent"
	for elem in ${startQueue[@]}; do
		if [[ "$elem" == "$parent" ]]; then
			echo "Steps to find: $steps"
			distances["$startX,$startY"]=$steps
			exit
		fi
	done
	par=$parent
	steps=$(($steps+1))
done

