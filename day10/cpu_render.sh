#!/bin/bash

if [ "$#" -gt 0 ]; then
    printf '%s\n' "$@"
fi

old_tty=$(stty --save)
stty raw -echo min 0

addxCycles=2

currentCycle=1
X=1
#signalStrengths=()

drawPos=0

function draw {
    char="."
    if [[ $drawPos -eq $(($X-1)) || $drawPos -eq $X || $drawPos -eq $(($X+1)) ]]; then
        char="#"
    fi

    if [[ $(($currentCycle%40)) -eq 0 ]]; then
        drawPos=0
	echo "$char"
    else
	drawPos=$(($drawPos+1))
	printf "$char"
    fi
}

#function checkLoopNum {
#    echo "Loop $currentCycle"
#    if [[ $currentCycle -eq 20 || $((($currentCycle-20)%40)) -eq 0 ]]; then
#        #echo "		Loop 20 or 20+40*z - $currentCycle - $X"
#	signal=$(($currentCycle*$X))
#	signalStrengths+=( "$signal" )
#	#echo "		Signal strength $signal"
#    fi
#}

while IFS= read -r string; do
    IFS=" " read -ra inst <<< $string
    if [[ "${inst[0]}" == "noop" ]]; then 
        #echo "	NOOP"
	#checkLoopNum
	draw
	currentCycle=$(($currentCycle+1))
    elif [[ "${inst[0]}" == "addx" ]]; then
        #echo "	ADDX ${inst[1]}"
        for i in $(seq 1 $addxCycles); do
	    #checkLoopNum
	    draw
	    currentCycle=$(($currentCycle+1))
	done
	X=$(($X+${inst[1]}))
    fi
done

#totalSignal=0
#for elem in ${signalStrengths[@]}; do
#    totalSignal=$(($totalSignal+$elem))
#done
#echo "Total signal strength: $totalSignal"
stty $old_tty
