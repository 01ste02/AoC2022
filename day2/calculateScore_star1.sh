#!/bin/bash
score=0
x_score=1
y_score=2
z_score=3
win_score=6
draw_score=3
loose_score=0
if [ "$#" -gt 0 ]; then
    printf '%s\n' "$@"
fi
while IFS= read -r string; do
	#rounds+=( "$(echo $string | sed 's/ /,/g')" )
	IFS=' ' read -ra round <<< "$string"
	if [[ "${round[0]}" == "A" ]]; then #Rock
		case "${round[1]}" in
			"X") score=$(($draw_score+$x_score+$score));; #Rock - DRAW
			"Y") score=$(($win_score+$y_score+$score));; #Paper - WIN
			"Z") score=$(($loose_score+$z_score+$score));; #Scissors - LOSS
		esac
	elif [[ "${round[0]}" == "B" ]]; then #Paper
		case "${round[1]}" in
			"X") score=$(($loose_score+$x_score+$score));; #Rock - LOSS
                        "Y") score=$(($draw_score+$y_score+$score));; #Paper - DRAW
                        "Z") score=$(($win_score+$z_score+$score));; #Scissors - WIN
                esac
	elif [[ "${round[0]}" == "C" ]]; then #Scissors
		case "${round[1]}" in
			"X") score=$(($win_score+$x_score+$score));; #Rock - WIN
                        "Y") score=$(($loose_score+$y_score+$score));; #Paper - LOSS
                        "Z") score=$(($draw_score+$z_score+$score));; #Scissors - DRAW
                esac
	fi
done

echo "$score"
