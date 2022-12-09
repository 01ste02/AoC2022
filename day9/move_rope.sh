#!/bin/bash

if [ "$#" -gt 0 ]; then
    printf '%s\n' "$@"
fi



head_x=50
head_y=50
tail_x=50
tail_y=50
num_visited_positions=1
visited="[$tail_x,$tail_y] "

function check_tail_distance {
    echo $(echo $(((head_x-tail_x)*(head_x-tail_x)+(head_y-tail_y)*(head_y-tail_y))) | awk '{print sqrt($1)}' | sed 's/,/./g')
}

function set_init {
    initial_x=$head_x
    initial_y=$head_y
}

function handle_tail_move {
    if [[ "$(echo "$(check_tail_distance) >= 2" | bc -l)" == "1" ]]; then
        tail_x=$initial_x
	tail_y=$initial_y
	if [[ ! "$visited" == *"[$tail_x,$tail_y]"* ]]; then
	    echo "		Never visited [$tail_x,$tail_y] , increasing visited counter"
	    num_visited_positions=$(($num_visited_positions+1))
	else 
	    echo "		Visited [$tail_x,$tail_y] already, not touching counter"
	fi
	visited+=" [$tail_x,$tail_y] "
	echo "	Moved tail"
    fi
}

while IFS= read -r string; do
    IFS=" " read -ra move <<< $string
    if [[ "${move[0]}" == "R" ]]; then
        for i in $(seq 1 ${move[1]}); do
	    set_init
	    head_x=$(($head_x+1))
	    echo "	Moved head R - distance is now $(check_tail_distance)"
	    handle_tail_move
	done
    elif [[ "${move[0]}" == "L" ]]; then
	for i in $(seq 1 ${move[1]}); do
	    set_init
	    head_x=$(($head_x-1))
	    echo "	Moved head L - distance is now $(check_tail_distance)"
	    handle_tail_move
        done
    elif [[ "${move[0]}" == "U" ]]; then
	for i in $(seq 1 ${move[1]}); do
	    set_init
	    head_y=$(($head_y+1))
	    echo "	Moved head U - distance is now $(check_tail_distance)"
	    handle_tail_move
        done
    elif [[ "${move[0]}" == "D" ]]; then
	for i in $(seq 1 ${move[1]}); do
            set_init
	    head_y=$(($head_y-1))
	    echo "	Moved head D - distance is now $(check_tail_distance)"
	    handle_tail_move
        done
    fi
done

echo "Num visited by tail: $num_visited_positions"
