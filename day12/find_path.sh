#!/bin/bash
if [ "$#" -gt 0 ]; then
    printf '%s\n' "$@"
fi

declare -A map

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
    local fromX=$3
    local fromY=$4

    possibilities=""
    for x in $(seq $(($X-1)) $(($X+1))); do
	for y in $(seq $(($Y-1)) $(($Y+1))); do
	    #echo "	Checking $x $y" >&2
            if ! [[ $fromX -eq $x && $fromY -eq $y ]] && ! [[ $X -eq $x && $Y -eq $y ]] && [[ $x -ge 0 && $x -lt ${#map[0]} && $y -ge 0 && $y -lt $row ]] && [[ $x -eq $X || $y -eq $Y ]] ; then
		current=$(getKeyCode $X $Y)
		next=$(getKeyCode $x $y)
		#echo "		$x $y passed the coord check, onto keycode $current $next" >&2
		if [[ "$current $(($current+1))" ==  *"$next"* ]] || [[ $next -lt $current && ! $next -eq 83 ]] || [[ $current -eq 83 ]]; then
		    #echo "		$x $y was valid" >&2
		    if [[ $next -ge $current ]]; then
		        possibilities="$x,$y $possibilities"
		    else
			possibilities="$possibilities $x,$y "
		    fi
	    	fi
	    fi
	done
    done
    #echo $possibilities >&2
    echo $possibilities
}

function tryPath () {
    local distance=$1
    local X=$2
    local Y=$3
    local lastX=$4
    local lastY=$5
    
    distance=$(($distance+1))
    echo "X: $X Y: $Y Row: ${map[$Y]} Current char: ${map[$Y]:$X:1} Distance: $distance" >&2

    if [[ "${map[$Y]:$X:1}" == "E" ]]; then
        #I am at the target, return
	echo "Found it at $X $Y, distance $(($distance-1))!" >&2
	echo $(($distance-1))
	sleep 5
    elif [[ $distance -le $numSpots ]]; then

        declare -A paths
        counter=0
        for coord in $(findPossiblePaths $X $Y $lastX $lastY); do
            counter=$(($counter+1))
            IFS="," read -ra xy <<< $coord
	    #sleep 1
	    paths[$counter]=$(tryPath $distance ${xy[0]} ${xy[1]} $X $Y)
        done

        #sleep 1
        if [[ $counter -eq 0 ]]; then #No paths could be tried
	    echo "	No goal" >&2
            echo "-"
        else
            IFS=$'\n' sorted=($(sort -n <<<"${paths[*]}"))
	    echo "	Returning ${sorted[0]}"
	    echo ${sorted[0]}
        fi
    else
        echo "	Too great distance" >&2
	echo "-"
    fi
}



echo "Shortest path? $(tryPath 0 $startX $startY $startX $startY)"
