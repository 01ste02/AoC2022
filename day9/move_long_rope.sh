#!/bin/bash

if [ "$#" -gt 0 ]; then
    printf '%s\n' "$@"
fi

declare -A rope

for i in $(seq 1 10); do
    echo $i
    rope[$i]="50,50"
    render
done

num_visited_positions=1
visited="[$tail_x,$tail_y] "

function check_distance () { #Front Rear
    IFS="," read -ra cordf <<< $1
    IFS="," read -ra cordr <<< $2
    echo $(echo $(((${cordf[0]}-${cordr[0]})*(${cordf[0]}-${cordr[0]})+(${cordf[1]}-${cordr[1]})*(${cordf[1]}-${cordr[1]}))) | awk '{print sqrt($1)}' | sed 's/,/./g')
}

function set_init () { #Rope-node
    IFS="," read -ra cord <<< $1
    initial_x=${cord[0]}
    initial_y=${cord[1]}
}

function render {
    row=""
    for ind in $(seq 1 100); do
        row+="."
    done
    declare -A matrix
    for ind in $(seq 1 100); do
        matrix[$ind]=$row
    done
    for ind in $(seq 1 10); do
        IFS="," read -ra cord <<< ${rope[$ind]}
	matrix[${cord[1]}]="$(echo ${matrix[${cord[1]}]} | sed s/./$(($ind-1))/${cord[0]})"
    done

    for ind in $(seq 100 -1 30); do
        echo ${matrix[$ind]}
    done
}

function handle_move {
    for i in $(seq 1 9); do
        tmp_init_x=$initial_x
	tmp_init_y=$initial_y
	j=$(($i+1))
	echo "$tmp_init_x,$tmp_init_y"
	set_init ${rope[$j]}
	echo "$tmp_init_x,$tmp_init_y"

	echo "Rope 1 ${rope[$i]} Rope 2: ${rope[$j]}"
	echo $(check_distance ${rope[$i]} ${rope[$j]})
	if [[ "$(echo "$(check_distance ${rope[$i]} ${rope[$j]}) >= 2" | bc -l)" == "1" ]]; then
	    IFS="," read -ra cord <<< ${rope[$j]}
            rope[$j]="$tmp_init_x,$tmp_init_y"
	    #render
            echo "		Moved $j to [$tmp_init_x,$tmp_init_y] because $i was too far away"
	    if [[ $j -eq 10 ]]; then
		render
		#if [[ ! "$visited" == *"[$tmp_init_x,$tmp_init_y]"* ]]; then
	        #    echo "		Never visited [$tmp_init_x,$tmp_init_y] , increasing visited counter"
	        #    num_visited_positions=$(($num_visited_positions+1))
	        #else 
	        #    echo "		Visited [$tmp_init_x,$tmp_init_y] already, not touching counter"
	        #fi
	        #visited+=" [$tmp_init_x,$tmp_init_y] "
	        #echo "	Moved tail"
            fi
	fi
    done
    if [[ ! "$visited" == *"[${rope[10]}]"* ]]; then
        echo "              Never visited [${rope[10]}] , increasing visited counter"
        num_visited_positions=$(($num_visited_positions+1))
    else
        echo "              Visited [${rope[10]}] already, not touching counter"
    fi
    visited+=" [${rope[10]}] "
    echo "  Moved tail"
}


function move_2 {
    for i in $(seq 1 9); do
	j=$(($i+1))
        IFS="," read -ra one <<< ${rope[$i]}
	o_x=${one[0]}
	o_y=${one[1]}
	IFS="," read -ra two <<< ${rope[$j]}
        t_x=${two[0]}
        t_y=${two[1]}
        #echo "$i: $o_x,$o_y  $t_x,$t_y"
	if [[ $o_x -eq $t_x && $(($o_y-$t_y)) -eq 2 ]]; then #Y-pos
		rope[$j]="$t_x,$(($t_y+1))"
	elif [[ $o_x -eq $t_x && $(($o_y-$t_y)) -eq -2 ]]; then #Y-neg
		rope[$j]="$t_x,$(($t_y-1))"
	elif [[ $(($o_x-$t_x)) -eq 2 && $o_y -eq $t_y ]]; then #X-pos
		rope[$j]="$(($t_x+1)),$t_y"
	elif [[ $(($o_x-$t_x)) -eq -2 && $o_y -eq $t_y ]]; then #X-neg
	        rope[$j]="$(($t_x-1)),$t_y"
	elif [[ $(($o_x-$t_x)) -eq 1 && $(($o_y-$t_y)) -eq 2 ]]; then #Diag Y-pos, X-pos
		rope[$j]="$(($t_x+1)),$(($t_y+1))"
	elif [[ $(($o_x-$t_x)) -eq -1 && $(($o_y-$t_y)) -eq 2 ]]; then #Diag Y-pos, X-pos
                rope[$j]="$(($t_x-1)),$(($t_y+1))"
	elif [[ $(($o_x-$t_x)) -eq 1 && $(($o_y-$t_y)) -eq -2 ]]; then #Diag Y-pos, X-pos
                rope[$j]="$(($t_x+1)),$(($t_y-1))"
	elif [[ $(($o_x-$t_x)) -eq -1 && $(($o_y-$t_y)) -eq -2 ]]; then #Diag Y-pos, X-pos
                rope[$j]="$(($t_x-1)),$(($t_y-1))"
	elif [[ $(($o_x-$t_x)) -eq 2 && $(($o_y-$t_y)) -eq 1 ]]; then #Diag Y-pos, X-pos
                rope[$j]="$(($t_x+1)),$(($t_y+1))"
        elif [[ $(($o_x-$t_x)) -eq -2 && $(($o_y-$t_y)) -eq 1 ]]; then #Diag Y-pos, X-pos
                rope[$j]="$(($t_x-1)),$(($t_y+1))"
        elif [[ $(($o_x-$t_x)) -eq 2 && $(($o_y-$t_y)) -eq -1 ]]; then #Diag Y-pos, X-pos
                rope[$j]="$(($t_x+1)),$(($t_y-1))"
        elif [[ $(($o_x-$t_x)) -eq -2 && $(($o_y-$t_y)) -eq -1 ]]; then #Diag Y-pos, X-pos
                rope[$j]="$(($t_x-1)),$(($t_y-1))"
	elif [[ $(($o_x-$t_x)) -eq 2 && $(($o_y-$t_y)) -eq 2 ]]; then #Diag Y-pos, X-pos
                rope[$j]="$(($t_x+1)),$(($t_y+1))"
        elif [[ $(($o_x-$t_x)) -eq -2 && $(($o_y-$t_y)) -eq 2 ]]; then #Diag Y-pos, X-pos
                rope[$j]="$(($t_x-1)),$(($t_y+1))"
        elif [[ $(($o_x-$t_x)) -eq 2 && $(($o_y-$t_y)) -eq -2 ]]; then #Diag Y-pos, X-pos
                rope[$j]="$(($t_x+1)),$(($t_y-1))"
        elif [[ $(($o_x-$t_x)) -eq -2 && $(($o_y-$t_y)) -eq -2 ]]; then #Diag Y-pos, X-pos
                rope[$j]="$(($t_x-1)),$(($t_y-1))"
	fi
	#render
    done

    if [[ ! "$visited" == *"[${rope[10]}]"* ]]; then
        #echo "              Never visited [${rope[10]}] , increasing visited counter"
        num_visited_positions=$(($num_visited_positions+1))
    #else
        #echo "              Visited [${rope[10]}] already, not touching counter"
    fi
    visited+=" [${rope[10]}] "
    #echo "  Moved tail"
}

itr=0
while IFS= read -r string; do
    IFS=" " read -ra move <<< $string
    echo "$itr of 2000"
    itr=$(($itr+1))
    if [[ "${move[0]}" == "R" ]]; then
        for i in $(seq 1 ${move[1]}); do
	    set_init ${rope[1]}
	    IFS="," read -ra cord <<< ${rope[1]}
	    rope[1]="$((${cord[0]}+1)),${cord[1]}"
	    #echo "	Moved head R - distance is now $(check_distance ${rope[1]} ${rope[2]})"
	    move_2
	done
    elif [[ "${move[0]}" == "L" ]]; then
	for i in $(seq 1 ${move[1]}); do
	    set_init ${rope[1]}
            IFS="," read -ra cord <<< ${rope[1]}
            rope[1]="$((${cord[0]}-1)),${cord[1]}"
	    #echo "	Moved head L - distance is now $(check_distance ${rope[1]} ${rope[2]})"
	    move_2
        done
    elif [[ "${move[0]}" == "U" ]]; then
	for i in $(seq 1 ${move[1]}); do
	    set_init ${rope[1]}
            IFS="," read -ra cord <<< ${rope[1]}
	    rope[1]="${cord[0]},$((${cord[1]}+1))"
	    #echo "	Moved head U - distance is now $(check_distance ${rope[1]} ${rope[2]})"
	    move_2
        done
    elif [[ "${move[0]}" == "D" ]]; then
	for i in $(seq 1 ${move[1]}); do
	    set_init ${rope[1]}
            IFS="," read -ra cord <<< ${rope[1]}
            rope[1]="${cord[0]},$((${cord[1]}-1))"
	    #echo "	Moved head D - distance is now $(check_distance ${rope[1]} ${rope[2]})"
	    move_2
        done
    fi
done

echo "Num visited by tail: $num_visited_positions"
