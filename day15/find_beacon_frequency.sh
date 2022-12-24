#!/bin/bash

if [ "$#" -gt 0 ]; then
    printf '%s\n' "$@"
fi

declare -A sensors 
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

function abs () { if [[ $1 -lt 0 ]]; then echo $((0-($1))); else echo $1; fi }

function valid () {
	for key in ${!sensors[@]}; do
		IFS="," read -ra coords <<< "$key"
		if [[ $(($(abs $((${coords[0]}-($1))))+$(abs $((${coords[1]}-($2)))))) -le ${sensors[$key]} ]]; then #$(bc -l <<< "(sqrt(((${coords[0]})-($1))^2+((${coords[1]})-($2))^2)) <= ${sensors[$key]}") -eq 1 ]]; then
			echo 0
			exit
		fi
	done
	echo 1
}

while IFS= read -r string; do
	echo $string
	x=$(sed -r 's/Sensor at x=//g;s/(-?[[:digit:]]*).*/\1/g' <<< $string)
	y=$(sed -r 's/Sensor at x=-?[[:digit:]]*, y=//g;s/(-?[[:digit:]]*):.*/\1/g' <<< $string)
	b_x=$(sed -r 's/.* closest beacon is at x=//g;s/(-?[[:digit:]]*),.*/\1/g' <<< $string)
	b_y=$(sed -r 's/.* closest beacon is at x=.*, y=//g;s/(-?[[:digit:]]*)/\1/g' <<< $string)
	
	#dist=$(BC_LINE_LENGTH=0 bc -l <<< "sqrt((($x)-($b_x))^2+(($y)-($b_y))^2)")
	dist=$(($(abs $(($x-($b_x))))+$(abs $(($y-($b_y))))))
	sensors["$x,$y"]="$dist"
	beacons["$b_x,$b_y"]=1
	echo "	Sensor: $x,$y"
	echo "	Beacon: $b_x,$b_y"
	
#	dist=$(BC_LINE_LENGTH=0 bc -l <<< "sqrt((($x)-($b_x))^2+(($y)-($b_y))^2)")
#	#"$(sed 's/\-\-/+/g' <<< "sqrt(($x-$b_x)^2+($y-$b_y)^2)")")
#	if [[ "$dist" == *"."* ]]; then
#		dist=$(($(sed -r 's/([[:digit:]]*)\..*/\1/g' <<< $dist)+1))
#	fi
#	#echo "		Distance: $dist	Actual: $(BC_LINE_LENGTH=0 bc -vl <<< "sqrt(($x-$b_x)^2+($y-$b_y)^2)")"
#	for t_x in $(seq $(($x-$dist)) $(($x+$dist))); do
#		for t_y in $(seq $(($y-$dist)) $(($y+$dist))); do
#			if [[ $(BC_LINE_LENGTH=0 bc -l <<< "$(sed 's/\-\-/+/g' <<< "sqrt(($x-$t_x)^2+($y-$t_y)^2) <= $dist")") -eq 1 ]]; then
#				#echo "$t_x,$t_y"
#				if ! [[ "${beacons["$t_x,$t_y"]}" == "S" || "${beacons["$t_x,$t_y"]}" == "B" ]]; then
#					beacons["$t_x,$t_y"]="#"
#				fi
#			fi
#		done
#	done
	#render
done
#render
#echo "Num loops: $((${#sensors[@]}*${#sensors[@]}*4))*dir!"
numLoop=0
found=0

#echo "${!sensors[@]}"
#echo "${sensors[@]}"

for key in ${!sensors[@]}; do
	dist=${sensors[$key]}
	IFS="," read -r sensX sensY <<< $key
	#sensX=${coords[0]}
	#sensY=${coords[1]}
	echo "New key"
	for x_dist in $(seq 0 $dist); do
		#echo "	New dist"
		y_dist=$(($dist+1-$x_dist))
		for dir in "1,1" "1,-1" "-1,1" "-1,-1"; do #${dirs[@]}; do
			#echo "		New dir"
			#echo $dir
			IFS="," read -r dir_x dir_y <<< $dir
			x=$(($sensX+($x_dist*$dir_x)))
			y=$(($sensY+($y_dist*$dir_y)))
			numLoop=$(($numLoop+1))
			if [[ $(bc <<< "$numLoop % 1000") -eq 0 ]]; then echo "		Num loops: $numLoop"; fi
			if [[ $x -ge 0 && $x -le 4000000 && $y -ge 0 && $y -le 4000000 ]]; then
				absX=$(($x-($sensX)))
                        	absX=${absX#-}
                        	absY=$(($y-($sensY)))
                        	absY=${absY#-}
				if [[ ! $((($absX+$absY) == ($dist+1))) ]]; then break; fi

				if [[ $(valid $x $y) -eq 1 && $found -eq 0 ]]; then
					echo "Found: $((($x*4000000)+$y))"
					found=1
					exit
				fi
			fi
		done
	done
done
