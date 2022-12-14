#!/bin/bash

if [ "$#" -gt 0 ]; then
    printf '%s\n' "$@"
fi


declare -A occupied
maxY=0
minX=10000
maxX=0

ts=$(date +%s%N)
for i in $(seq 0 1000); do
	for j in $(seq 0 1000); do
		occupied["$i,$j"]="."
	done
done
echo "Took $((($(date +%s%N) - $ts)/1000000))ms to allocate array space"

function render {
	clear
	if [[ $(($maxX-$minX)) -gt $(tput cols) ]]; then
		maxX=$((500+$(($(tput cols)/2))-2))
		minX=$((500-$(($(tput cols)/2))+2))
	fi

	for i in $(seq 0 $maxY); do
		for j in $(seq $minX $maxX); do
			printf "${occupied["$j,$i"]}"
		done
		printf "\n"
	done
}

while IFS= read -r string; do
	IFS='->' read -ra points <<< "$string"
	startPoint=""
	for point in ${points[@]}; do
		if [[ "$startPoint" == "" ]]; then
			startPoint="$point"
		fi
		IFS=',' read -ra coord1 <<< "$startPoint"
		x1=${coord1[0]}
		y1=${coord1[1]}
	
		IFS=',' read -ra coord2 <<< "$point"
       	        x2=${coord2[0]}
       	        y2=${coord2[1]}
       	        #echo "Rock line from $x1 $y1 to $x2 $y2"
		

		if [[ $y1 -gt $maxY ]]; then
			maxY=$y1
		fi
		if [[ $y2 -gt $maxY ]]; then
			maxY=$y2
		fi

		if [[ $x1 -gt $maxX ]]; then
			maxX=$x1
		fi
		if [[ $x2 -gt $maxX ]]; then
			maxX=$x2
		fi
		
		if [[ $x1 -lt $minX ]]; then
                        minX=$x1
                fi
                if [[ $x2 -lt $minX ]]; then
                        minX=$x2
                fi


		if [[ $x1 -le $x2 ]]; then
			seqStringX="$x1 $x2"
		else
			seqStringX="$x2 $x1"
		fi

		if [[ $y1 -le $y2 ]]; then
                        seqStringY="$y1 $y2"    
                else
                        seqStringY="$y2 $y1"    
                fi	

		for i in $(seq $seqStringX); do
			for j in $(seq $seqStringY); do
				occupied["$i,$j"]="#"
			done
		done
		startPoint="$point"
	done
done
minX=$(($minX-50))
maxX=$(($maxX+50))
maxY=$(($maxY+2))
for i in $(seq 0 1000); do
	occupied["$i,$maxY"]="#"
done

x="500"
y="0"
occupied["$x,$y"]="+"
render

numStationary=0
while [[ ! ${occupied["500,0"]} == "o" ]]; do
	setStationary=0
	if [[ ! ${occupied["$x,$(($y+1))"]} == "." ]]; then
		if [[ ${occupied["$(($x-1)),$(($y+1))"]} == "." ]]; then
			nextX=$(($x-1))
			nextY=$(($y+1))
		elif [[ ${occupied["$(($x+1)),$(($y+1))"]} == "." ]]; then
			nextX=$(($x+1))
			nextY=$(($y+1))
		else
			setStationary=1
		fi
	else
		nextX=$x
		nextY=$(($y+1))
	fi

	if [[ $x -lt $minX ]]; then
        	minX=$x
        elif [[ $x -gt $maxX ]]; then
        	maxX=$x
        fi

	if [[ $setStationary -eq 1 ]]; then
		numStationary=$(($numStationary+1))
		if [[ $x -eq 500 && $y -eq 0 ]]; then
                        break
                fi
		occupied["$x,$y"]="o"
		x=500
		y=0
		occupied["$x,$y"]="+"
	else
		occupied["$x,$y"]="."
		x=$nextX
		y=$nextY
		occupied["$x,$y"]="+"
	fi
	#render
done
render
echo "Stationary: $numStationary"
