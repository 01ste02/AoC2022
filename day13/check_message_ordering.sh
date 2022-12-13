#!/bin/bash
if [ "$#" -gt 0 ]; then
    printf '%s\n' "$@"
fi

declare -A pairOne
declare -A pairTwo
index=1
subIndex=1
while IFS= read -r string; do
	echo "String: $string indexSub: $subIndex"
	if [[ -z "$string" ]]; then
		# New pair, empty row
		echo "New pair"
		index=$(($index+1))
	elif [[ $subIndex -eq 1 ]]; then
		pairOne[$index]="$string"
		subIndex=$(($subIndex+1))
		echo "Adding string 1"
	elif [[ $subIndex -eq 2 ]]; then
		pairTwo[$index]="$string"
                subIndex=1
		echo "adding string 2"
	fi
done

function compareSubList () {
	llen=0
        strL=""
        while [[ ! "${leftList:$(($lInd+$llen)):1}" == "]" ]]; do
        	if [[ ! "${leftList:$(($lInd+$llen)):1}" == "[" ]]; then
			strL+="${leftList:$(($lInd+$llen)):1}"
		fi
        	llen=$(($llen+1))
        done

        rlen=0
        strR=""
        while [[ ! "${pairTwo[$i]:$(($rInd+$rlen)):1}" == "]" ]]; do
		if [[ ! ${pairTwo[$i]:$(($rInd+$rlen)):1} == "[" ]]; then
        		strR+="${pairTwo[$i]:$(($rInd+$rlen)):1}"
		fi
                rlen=$(($rlen+1))
        done
        echo "          Lists: Left: $strL Right: $strR"

        llInd=0
        rlInd=0
        while [[ 1 -eq 1 ]]; do
        	if [[ $rlInd -ge ${#strR} ]]; then
                	echo "          Right sub-list ran out first, so elements are not in the right order"
                        exitLoop=1
                        break
                elif [[ $llInd -ge ${#strL} ]]; then
                	echo "          Left sub-list ran out first, so continue"
                        break
		elif [[ $lChar =~ ^[0-9]+$ && $rChar =~ ^[0-9]+$ ]]; then # Both are numbers, compare
                        if [[ $lChar -gt $rChar ]]; then
                                echo "          Right side is smaller, so inputs are not in the right order"
                                break
                        elif [[ $lChar -eq $rChar ]]; then
                                echo "          Equal sides, move on"
                        else
                                echo "          Right side is larger, so inputs are in the right order"
                                correctIndices+=("$i")
                                break
                        fi
		elif [[ "$lChar" == "[" && $rChar == "[" ]]; then # Right is starting a list
                        compareSubList 
                fi


}

# Compare pairs

correctIndices=( )
for i in $(seq 1 $index); do
	lInd=1
	rInd=1
        lChar=""
	rChar=""
	
	exitLoop=0

	echo "	NEW STRING"

        while [[ 1 -eq 1 ]]; do
		if [[ $exitLoop -eq 1 ]]; then
			break;
		fi


		lChar="${pairOne[$i]:$lInd:1}"
        	rChar="${pairTwo[$i]:$rInd:1}"
		echo "	Left: $lChar Right: $rChar"
		if [[ $rInd -ge ${#pairTwo[$i]} ]]; then
			echo "		Right list ran out of items, so inputs are not in the right order."
			break
		elif [[ $lInd -ge ${#pairOne[$i]} ]]; then
			echo "		Left list ran out of items, so inputs are in the right order."
			correctIndices+=("$i")
			break
		elif [[ $lChar =~ ^[0-9]+$ && $rChar =~ ^[0-9]+$ ]]; then # Both are numbers, compare
	        	if [[ $lChar -gt $rChar ]]; then
				echo "		Right side is smaller, so inputs are not in the right order"
				break
			elif [[ $lChar -eq $rChar ]]; then
				echo "		Equal sides, move on"
			else
				echo "		Right side is larger, so inputs are in the right order"
				correctIndices+=("$i")
				break
			fi
		elif [[ "$lChar" == "[" && $rChar =~ ^[0-9]+$ ]]; then # Left is starting a list
                        llen=1
			strL=""
			while [[ ! "${pairOne[$i]:$(($lInd+$llen)):1}" == "]" ]]; do
				strL+="${pairOne[$i]:$(($lInd+$llen)):1}"
				llen=$(($llen+1))
			done

			rlen=0
			strR=""
			while [[ ! "${pairTwo[$i]:$(($rInd+$rlen)):1}" == "]" ]]; do
                                strR+="${pairTwo[$i]:$(($rInd+$rlen)):1}"
                                rlen=$(($rlen+1))
                        done
			echo "		Lists: Left: $strL Right: $strR"

			llInd=0
			rlInd=0
			while [[ 1 -eq 1 ]]; do
				if [[ $rlInd -ge ${#strR} ]]; then
					echo "		Right sub-list ran out first, so elements are not in the right order"
					exitLoop=1
					break
				elif [[ $llInd -ge ${#strL} ]]; then
					echo "		Left sub-list ran out first, so continue"
					break

				
		elif [[ "$rChar" == "[" && $lChar =~ ^[0-9]+$ ]]; then # Right is starting a list
			echo "Not yet"
		fi
		echo "	Increasing indices"
		if [[ "$lChar" == "[" && "$rChar" == "[" ]]; then
			lInd=$(($lInd+1))
			rInd=$(($rInd+1))
		else
			lInd=$(($lInd+1))
                        rInd=$(($rInd+1))
		fi
	done
		
done
