#!/bin/bash
if [ "$#" -gt 0 ]; then
    printf '%s\n' "$@"
fi


declare -A monkeyItems
declare -A monkeyOperations
declare -A monkeyTests
declare -A monkeyTrue
declare -A monkeyFalse

monkey=0
while IFS= read -r string; do
    if [[ -z "$string" ]]; then
        #We have an empty line - new monkey 
	monkey=$(($monkey+1))
    elif [[ "$string" == *"Starting items:"* ]]; then
	#We have items being listed
        monkeyItems[$monkey]="$(echo "$string" | sed 's/Starting items: //g' | sed -e 's/^[ \t]*//')"
    elif [[ "$string" == *"Operation:"* ]]; then
        monkeyOperations[$monkey]="$(echo "$string" | sed 's/Operation: //g' | sed -e 's/^[ \t]*//')"
    elif [[ "$string" == *"Test:"* ]]; then
	monkeyTests[$monkey]="$(echo "$string" | sed 's/Test: divisible by //g' | sed -e 's/^[ \t]*//')"
    elif [[ "$string" == *"If true:"* ]]; then
	monkeyTrue[$monkey]="$(echo "$string" | sed 's/If true: throw to monkey//g' | sed -e 's/^[ \t]*//')"
    elif [[ "$string" == *"If false:"* ]]; then
        monkeyFalse[$monkey]="$(echo "$string" | sed 's/If false: throw to monkey//g' | sed -e 's/^[ \t]*//')"
    else
	echo "Unexpected row:  $string"
    fi
done

lcm=1
for itm in ${monkeyTests[@]}; do
    lcm=$((lcm*itm))
done

declare -A numInspections
for i in $(seq 1 10000); do
    echo "Round $i of 10000"
    for j in $(seq 0 $monkey); do
	#echo "Monkey $j."
	IFS=", " read -ra items <<< ${monkeyItems[$j]}
        for item in ${items[@]}; do
	    numInspections[$j]="$((${numInspections[$j]} + 1))"
	    #echo "  Monkey inspects an item with a worry level of $item."
	    IFS=" " read -ra op <<< ${monkeyOperations[$j]}
	    calc="$(sed "s/old/$item/g" <<< ${op[@]:2})"
	    #worryLevel="$(BC_LINE_LENGTH=0 bc <<< "($calc)%$lcm")"
	    worryLevel="$((($calc)%$lcm))"
	    #echo "    Worry level is multiplied as $calc to $worryLevel."
            #worryLevel=$(echo "$worryLevel/3" | bc)
	    #echo "    Monkey gets bored with item. Worry level is divided by 3 to $worryLevel."
	    if [[ $(($worryLevel % ${monkeyTests[$j]})) -eq 0 ]]; then
	        #True
		#echo "    Current worry level is divisible by ${monkeyTests[$j]}"
		#monkeyItems[$j]="${items[@]/$item}"
		monkeyItems[${monkeyTrue[$j]}]+=", $worryLevel"
		#echo "    Item with worry level $worryLevel is thrown to monkey ${monkeyTrue[$j]}."
	    else
	        #False
		#echo "    Current worry level is not divisible by ${monkeyTests[$j]}"
                #monkeyItems[$j]="${items[@]:1}"
                monkeyItems[${monkeyFalse[$j]}]+=", $worryLevel"
                #echo "    Item with worry level $worryLevel is thrown to monkey ${monkeyFalse[$j]}."
	    fi
	done
	monkeyItems[$j]=""
    done
done

IFS=$'\n' sorted=($(sort -n -r <<<"${numInspections[*]}"))
unset IFS

echo "Level: $(echo "${sorted[0]}*${sorted[1]}" | bc )"
