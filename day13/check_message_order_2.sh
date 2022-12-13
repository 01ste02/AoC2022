#!/bin/bash
if [ "$#" -gt 0 ]; then
    printf '%s\n' "$@"
fi

declare -A pairOne
declare -A pairTwo

function compare () {
	local index=$1
	local i=1
	local j=1
	local iMax=${pairOne["$index,0"]}	
	local jMax=${pairTwo["$index,0"]}

	local left="${pairOne["$index,$i"]}"
	local right="${pairTwo["$index,$j"]}"
	echo "	Comparing: Left: $left Right: $right"
	IFS="," read -ra lArr <<< "$left"
	IFS="," read -ra rArr <<< "$right"
	

	a=0
	while [[ $a -lt ${#lArr[@]} && $a -lt ${#rArr[@]} ]]; do
		echo "L: ${lArr[$a]} R: ${rArr[$a]}"
		l="${lArr[$a]}"
		r="${rArr[$a]}"
		if [[ $l -lt $r ]]; then
                        echo "-1"
			exit
                elif [[ $l -eq $r ]]; then
                        echo "0"
                else
                        echo "1"
                        exit
                fi
		a=$(($a+1))
	done

	if [[ $a -eq ${#lArr[@]} && $a -lt ${#rArr[@]} ]]; then 
                echo "-1"
        	exit
        elif [[ $a -lt ${#lArr[@]} && $a -eq ${#rArr[@]} ]]; then
                echo "1"
        	exit
        fi


	#if [[ "${left:0:1}" == "(" && "${right:0:1}" == "(" ]]; then
	#	echo "	Lists start here, Left: $left Right: $right" >&2
	#	echo "	Modified: Left: ${left:1:$(($(echo $left |  awk -F")" '{print length($0)-length($NF)}')-2))} Right: ${right:1:$(($(echo $right |  awk -F")" '{print length($0)-length($NF)}')-2))}" >&2
	#	leftList="${left:1:$(($(echo $left |  awk -F")" '{print length($0)-length($NF)}')-2))}"
	#        rightList="${right:1:$(($(echo $right |  awk -F")" '{print length($0)-length($NF)}')-2))}"
	#	i=0
 
	#	IFS=" " read -ra l <<< $leftList
	#	for elem in ${l[@]}; do
	#		if [[ "${elem:0:1}" == "(" ]]; then
	#			echo "		Elem is list, compare again"
	#		fi
	#		echo "		$elem"
	#	done
	#	exit
	#	#while [[ $i -lt ${#leftList}
	#	if [[ $res -eq -1 ]]; then
	#		echo "-1"
	#		exit
	#	elif [[ $res -eq 1 ]]; then
	#		echo "1"
	#		exit
	#	fi
        #       
	#fi
}





index=1
subIndex=1
while IFS= read -r string; do
        #echo "String: $string indexSub: $subIndex"
        if [[ -z "$string" ]]; then
                # New pair, empty row
		echo "$(compare $index)"
		#echo "New pair"
                index=$(($index+1))
        elif [[ $subIndex -eq 1 ]]; then
		IFS="[]" read -ra str <<< $string
		i=1
		pairOne["$index,0"]=0
		for elem in ${str[@]}; do
			mod="$(echo $elem | sed 's/,\[//g;s/\[//g')"
			mod="${mod#","}"
			mod="${mod%","}"
			if [[ ! -z "$mod" ]]; then
				pairOne["$index,$i"]="$mod"
				pairOne["$index,0"]=$i
				#echo "	One: ${mod#","}"
				i=$(($i+1))
			fi
		done
                subIndex=$(($subIndex+1))
                #echo "Adding string 1"
        elif [[ $subIndex -eq 2 ]]; then
		IFS="[]" read -ra str <<< $string
		i=1
		pairTwo["$index,0"]=0
		for elem in ${str[@]}; do
                        mod="$(echo $elem | sed 's/,\[//g;s/\[//g')"
                        mod="${mod#","}"
                        mod="${mod%","}"
                        if [[ ! -z "$mod" ]]; then
                                pairTwo["$index,$i"]="$mod"
				pairTwo["$index,0"]=$i
                                #echo "	Two: ${mod#","}"
                                i=$(($i+1))
                        fi
                done
                subIndex=1
                #echo "Adding string 2"
        fi
done
