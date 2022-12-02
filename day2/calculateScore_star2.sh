#!/bin/bash
score=0
r_score=1
p_score=2
s_score=3
win_score=6
draw_score=3
loose_score=0
if [ "$#" -gt 0 ]; then
    printf '%s\n' "$@"
fi
while IFS= read -r string; do
	#rounds+=( "$(echo $string | sed 's/ /,/g')" )
	IFS=' ' read -ra round <<< "$string"
	if [[ "${round[1]}" == "X" ]]; then #LOSS
		case "${round[0]}" in
			"A") score=$(($loose_score+$s_score+$score));; #Scissors
			"B") score=$(($loose_score+$r_score+$score));; #Rock
			"C") score=$(($loose_score+$p_score+$score));; #Paper
		esac
	elif [[ "${round[1]}" == "Y" ]]; then #DRAW
		case "${round[0]}" in
			"A") score=$(($draw_score+$r_score+$score));; #Rock
                        "B") score=$(($draw_score+$p_score+$score));; #Paper
                        "C") score=$(($draw_score+$s_score+$score));; #Scissors
                esac
	elif [[ "${round[1]}" == "Z" ]]; then #WIN
		case "${round[0]}" in
			"A") score=$(($win_score+$p_score+$score));; #Paper
                        "B") score=$(($win_score+$s_score+$score));; #Scissors
                        "C") score=$(($win_score+$r_score+$score));; #Rock
                esac
	fi
done
#Rock
#Paper
#Scissors
echo "$score"
