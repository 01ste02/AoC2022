#!/bin/bash
if [ "$#" -gt 0 ]; then
    printf '%s\n' "$@"
fi


function compare() {
	left="$1"
	right="$2"
	echo "	Left: $left Right: $right" >&2
	if [[ ${#left} -eq 1 && ${#right} -eq 1 ]]; then
		if [[ $left -lt $right ]]; then
			echo "-1"
			exit
		elif [[ $left -eq $right ]]; then
			echo "0"
			exit
		else
			echo "1"
			exit
		fi
	elif [[ -z "$left" && ! -z "$right" ]]; then
		echo "-1"
		exit
	elif [[ -z "$right" ]]; then
		echo "1"
		exit
	else
		if [[ "$left" == *"_"* ]]; then
			numDelimit=0
			delimit=""
			while [[ 1 -eq 1 ]]; do
				echo "Trying: ${left:$numDelimit:1}" >&2
				if [[ "${left:$numDelimit:1}" =~ ^[0-9]+$ || "${left:$numDelimit:1}" == "," ]]; then
					break
				fi
				numDelimit=$(($numDelimit+1))
				delimit+="_"
				sleep 1
			done
	
			actualString=0
	
			while [[ 1 -eq 1 ]]; do
				echo "Num delim: $numDelimit Result: ${left:$(($numDelimit+$actualString)):$numDelimit}" >&2
				if [[ "${left:$(($numDelimit+$actualString)):$numDelimit}" == "$delimit" ]]; then
					echo "	Result: ${left:$numDelimit:$actualString}" >&2
					break
				fi
				actualString=$(($actualString+1))
				sleep 1
			done
		fi

		if [[ "$right" == *"_"* ]]; then
                        numDelimit=0
                        delimit=""
                        while [[ 1 -eq 1 ]]; do
                                echo "Trying: ${left:$numDelimit:1}" >&2
                                if [[ "${left:$numDelimit:1}" =~ ^[0-9]+$ || "${left:$numDelimit:1}" == "," ]]; then
                                        break
                                fi
                                numDelimit=$(($numDelimit+1))
                                delimit+="_"
                                sleep 1
                        done

                        actualString=0

                        while [[ 1 -eq 1 ]]; do
                                echo "Num delim: $numDelimit Result: ${left:$(($numDelimit+$actualString)):$numDelimit}" >&2
                                if [[ "${left:$(($numDelimit+$actualString)):$numDelimit}" == "$delimit" ]]; then
                                        echo "  Result: ${left:$numDelimit:$actualString}" >&2
                                        break
                                fi
                                actualString=$(($actualString+1))
                                sleep 1
                        done
                fi


		#echo "		Group? $(grep -oP '(?<=_).*(?=_)' <<< $left)"
	fi
}



switch=0
left=""
right=""
while IFS='\n\n' read -r string; do
	if [[ -z "$string" ]]; then
		echo "New group"
	elif [[ $switch -eq 0 ]]; then
		echo "$string"
		left=""
		numOpen=0
		for char in $(sed -e 's/\(.\)/\1\n/g' <<< "$string"); do
			if [[ "$char" == "[" ]]; then
				numOpen=$(($numOpen+1))
				for i in $(seq 2 $numOpen); do
                                        left+='_'
                                done
			elif [[ "$char" == "]" ]]; then
				for i in $(seq 2 $numOpen); do
                                        left+='_'
                                done
				numOpen=$(($numOpen-1))
			else
				left+="$char"
			fi
		done
		switch=1
	else
		echo "$string"
		right=""
		numOpen=0
		for char in $(sed -e 's/\(.\)/\1\n/g' <<< "$string"); do
                        if [[ "$char" == "[" ]]; then
                                numOpen=$(($numOpen+1))
                                for i in $(seq 2 $numOpen); do
                                        right+='_'
                                done
                        elif [[ "$char" == "]" ]]; then
				for i in $(seq 2 $numOpen); do
                                        right+='_'
                                done
                                numOpen=$(($numOpen-1))
                        else
                                right+="$char"
                        fi
                done
		switch=0
		echo "$(compare $left $right)"
		echo "Done with group"
	fi
	  
done

