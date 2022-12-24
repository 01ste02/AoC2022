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
	y=$(sed -r 's/Sensor at x=(-?[[:digit:]]*), y=//g;s/(-?[[:digit:]]*):.*/\1/g' <<< $string)
	b_x=$(sed -r 's/.* closest beacon is at x=//g;s/(-?[[:digit:]]*),.*/\1/g' <<< $string)
	b_y=$(sed -r 's/.* closest beacon is at x=.*, y=//g;s/(-?[[:digit:]]*)/\1/g' <<< $string)
	
	#dist=$(BC_LINE_LENGTH=0 bc -l <<< "sqrt((($x)-($b_x))^2+(($y)-($b_y))^2)")
	absX=$(($x-($b_x)))
        absX=${absX#-}
        absY=$(($y-($b_y)))
        absY=${absY#-}
	dist=$(($absX+$absY))
	#dist=$(($(abs $(($x-($b_x))))+$(abs $(($y-($b_y))))))
	sensors["$x,$y"]="$dist"
	beacons["$b_x,$b_y"]="Found"
	echo "	Sensor: $x,$y"
#	echo "	Beacon: $b_x,$b_y"
	
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


numImpossible=0
#for i in $(seq -100 100); do
#	if [[ "${beacons["$i,$1"]}" == "#" ]]; then
#		numImpossible=$(($numImpossible+1))
#	fi
#done

#function runTest () {
#	x=$1
#	y=$2
#	echo "Testing $x $y"
#       if [[ $(valid $x $y) -eq 0 && ! "${beacons["$x,$y"]}" == "1" ]]; then
#              numImpossible=$(($numImpossible+1))
#                echo "  Added 1"
#        fi
#}

loop=0
counter=0
rng=6000000
#rng=100
rng2=$(($rng*2))
y_t=$1
for x_t in $(seq -$rng $rng); do
	#echo "$(runTest $x_t $y_t)" &
	loop=$(($loop+1))
	counter=$(($counter+1))
	if [[ $counter -eq 5000 ]]; then echo "$loop/$rng2"; counter=0; fi
	good=true
	for xy in ${!sensors[@]}; do
		IFS=',' read -r x y <<< $xy
		#echo "$xy becomes $x, $y"
		absX=$((($x_t)-($x)))
		absX=${absX#-}
		absY=$((($y_t)-($y)))
                absY=${absY#-}
		#if [ $((($absX+$absY) <= ${sensors[$xy]})) ]; then
		#echo "$((($absX+$absY))) or $(bc <<< "$absX+$absY") and ${sensors[$xy]} from $x $y"
		case $((($absX+$absY) <= ${sensors[$xy]})) in
			1)	
				good=false;
				break
			;;
		esac
		#fi
	done
	if ! $good; then
		#echo "		HELLO"
		if [[ ! "${beacons["$x_t,$y_t"]}" == "Found" ]]; then 
			#echo "                          Added 1"
                        numImpossible=$(($numImpossible+1))
		#else
		#	echo "                          Found beacon ${beacons["$x_t,$y_t"]}"
		fi
		#if [[ ! -z "${beacons["$x_t,$y_t"]}" ]]; then
		#	numImpossible=$(($numImpossible+1))
		#fi
	fi
done
echo "Number: $numImpossible"

