#!/bin/bash
if [ "$#" -gt 0 ]; then
    printf '%s\n' "$@"
fi

declare -A filesystem

currentDir=""
while IFS= read -r string; do
    if [[ ! -z "$string" && "${string:0:1}" == "$" ]]; then
        # We are reading a command
        echo "Command: ${string:1}"
        
	if [[ "${string:2:5}" == "cd .." ]]; then
	    echo "	Changing PWD one layer up"
	    currentDir="${currentDir%/*}" #Greedy trim of the last bit after /
            if [[ -z "$currentDir" ]]; then
	        currentDir="/"
	    fi

	    echo "	New PWD: $currentDir"
	elif [[ "${string:2:4}" == "cd /" ]]; then
	    echo "	Changing PWD into ${string:5}"
	    currentDir="${string:5}"
	    echo "	New PWD: $currentDir"
	elif [[ "${string:2:2}" == "cd" ]]; then
	    echo "	Changing PWD one layer into ${string:5}"
	    if [[ "$currentDir" == "/" ]]; then
	        currentDir+="${string:5}"
	    else
	        currentDir+="/${string:5}"
	    fi
	    echo "	New PWD: $currentDir"
	fi
    elif [[ ! -z "$string" ]]; then
	# We are reading the command output
        echo "Output: $string"
        IFS=" " read -ra file <<< $string
	echo "Type: ${file[0]} name: ${file[1]}"
	if [[ ! "${file[0]}" == "dir" ]]; then
	    echo "	Found file of size ${file[0]} with name ${file[1]}"
	    #filesystem[$currentDir]=$((${filesystem[$currentDir]}+${file[0]}))
	    #echo "	Adding file size to dir ${currentDir%/*}"
            
	    IFS="/" read -ra dir <<< $currentDir
	    addDir=""
	    echo "     Adding file size to dir /"
	    filesystem[/]=$((${filesystem[/]}+${file[0]}))
	    echo "      New dir size for / ${filesystem[/]}"
	    for elem in ${dir[@]}; do
                echo "     Adding file size to dir $addDir/$elem"
		filesystem["$addDir/$elem"]=$((${filesystem["$addDir/$elem"]}+${file[0]}))
		echo "      New dir size for $addDir/$elem ${filesystem["$addDir/$elem"]}"
		addDir="$addDir/$elem"
		echo "New addDir $addDir"
	    done


	    #if [[ -z "${currentDir%/*}" && ! "$currentDir" == "/" ]]; then
	    #    #We are in subdirectory to /, add sum there
	    #	filesystem[/]=$((${filesystem[/]}+${file[0]}))
	    #elif [[ ! "$currentDir" == "/" ]]; then
	    #    filesystem[${currentDir%/*}]=$((${filesystem[${currentDir%/*}]}+${file[0]}))
	    #fi
	    echo "	New dir size ${filesystem[$currentDir]}"
	else
	    echo "	Found directory with name ${file[1]}"
	fi
    else
	echo "Empty row in input"
    fi
done

echo ""
echo ""
echo "Done with input"
echo ""
echo ""

#for dir in "${!filesystem[@]}"; do
#    echo $dir
#    if [[ -v filesystem[${dir%/*}] ]]; then 
#        filesystem[${dir%/*}]=$((${filesystem[${dir%/*}]}+${filesystem[$dir]}))
#    fi
#done

echo ""
echo ""

spaceFree=$((70000000-${filesystem[/]}))
echo "Free space $spaceFree"

needToFree=$((30000000-$spaceFree))

echo "Need to free $needToFree"

for dir in "${!filesystem[@]}"; do
    echo "Path: $dir Size: ${filesystem[$dir]}"
done

for dir in "${!filesystem[@]}"; do echo $dir ' - ' ${filesystem["$dir"]}; done | sort -n -k3 | 
while IFS= read -r row; do
    echo "Row: $row"
    IFS="  -  " read -ra size <<< $row
    echo "	Comparing ${size[1]} with needed space $needToFree"
    if [[ ${size[1]} -ge $needToFree ]]; then
        echo "Will delete ${size[0]} with size of ${size[1]}"
	break
    fi
done
