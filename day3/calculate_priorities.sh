#!/bin/bash

declare -A priorities
priorities[a]=1
priorities[b]=2
priorities[c]=3
priorities[d]=4
priorities[e]=5
priorities[f]=6
priorities[g]=7
priorities[h]=8
priorities[i]=9
priorities[j]=10
priorities[k]=11
priorities[l]=12
priorities[m]=13
priorities[n]=14
priorities[o]=15
priorities[p]=16
priorities[q]=17
priorities[r]=18
priorities[s]=19
priorities[t]=20
priorities[u]=21
priorities[v]=22
priorities[w]=23
priorities[x]=24
priorities[y]=25
priorities[z]=26
priorities[A]=27
priorities[B]=28
priorities[C]=29
priorities[D]=30
priorities[E]=31
priorities[F]=32
priorities[G]=33
priorities[H]=34
priorities[I]=35
priorities[J]=36
priorities[K]=37
priorities[L]=38
priorities[M]=39
priorities[N]=40
priorities[O]=41
priorities[P]=42
priorities[Q]=43
priorities[R]=44
priorities[S]=45
priorities[T]=46
priorities[U]=47
priorities[V]=48
priorities[W]=49
priorities[X]=50
priorities[Y]=51
priorities[Z]=52

prioritySum=0
if [ "$#" -gt 0 ]; then
    printf '%s\n' "$@"
fi
while IFS= read -r string; do
    half1=${string:0:${#string}/2} 
    half2=${string:${#string}/2:${#string}}
    i=0
    result=""

    while [ $i -ne ${#half1} ]; do
        char=${half1:$i:1}
	if [[ $half2 == *$char* ]]; then #Check if half2 contains char
            result+=$char
	    prioritySum=$(($prioritySum+priorities[$char]))
	    break
	fi
	i=$(($i+1))
    done
done
echo $prioritySum
