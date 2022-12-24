#!/bin/bash

if [ "$#" -gt 0 ]; then
    printf '%s\n' "$@"
fi

declare -A beacons
ts=$(date +%s%N)
#for i in $(seq -100 1000000); do
#	for j in $(seq -100 1000000); do
#		beacons["$i,$j"]="."
#	done
#done
echo "Took $((($(date +%s%N) - $ts)/1000000))ms to allocate array space"

function render {
	echo ""
	for i in $(seq -10 50); do
		for j in $(seq -5 50); do
			printf "${beacons["$j,$i"]}"
		done
		printf "\n"
	done
}


while IFS= read -r string; do
	echo $string
	x=$(sed -r 's/Sensor at x=//g;s/(-?[[:digit:]]*).*/\1/g' <<< $string)
	y=$(sed -r 's/Sensor at x=-?[[:digit:]]*, y=//g;s/(-?[[:digit:]]*):.*/\1/g' <<< $string)
	b_x=$(sed -r 's/.* closest beacon is at x=//g;s/(-?[[:digit:]]*),.*/\1/g' <<< $string)
	b_y=$(sed -r 's/.* closest beacon is at x=.*, y=//g;s/(-?[[:digit:]]*)/\1/g' <<< $string)
	
	beacons["$x,$y"]="S"
	beacons["$b_x,$b_y"]="B"
	echo "	Sensor: $x,$y"
	echo "	Beacon: $b_x,$b_y"
	
	dist=$(BC_LINE_LENGTH=0 bc -l <<< "sqrt((($x)-($b_x))^2+(($y)-($b_y))^2)")
	#"$(sed 's/\-\-/+/g' <<< "sqrt(($x-$b_x)^2+($y-$b_y)^2)")")
	if [[ "$dist" == *"."* ]]; then
		dist=$(($(sed -r 's/([[:digit:]]*)\..*/\1/g' <<< $dist)+1))
	fi
	#echo "		Distance: $dist	Actual: $(BC_LINE_LENGTH=0 bc -vl <<< "sqrt(($x-$b_x)^2+($y-$b_y)^2)")"
	for t_x in $(seq $(($x-$dist)) $(($x+$dist))); do
		for t_y in $(seq $(($y-$dist)) $(($y+$dist))); do
			if [[ $(BC_LINE_LENGTH=0 bc -l <<< "$(sed 's/\-\-/+/g' <<< "sqrt(($x-$t_x)^2+($y-$t_y)^2) <= $dist")") -eq 1 ]]; then
				#echo "$t_x,$t_y"
				if ! [[ "${beacons["$t_x,$t_y"]}" == "S" || "${beacons["$t_x,$t_y"]}" == "B" ]]; then
					beacons["$t_x,$t_y"]="#"
				fi
			fi
		done
	done
	#render
done
render

numImpossible=0
for i in $(seq -100 100); do
	if [[ "${beacons["$i,$1"]}" == "#" ]]; then
		numImpossible=$(($numImpossible+1))
	fi
done
echo "Number: $numImpossible"

