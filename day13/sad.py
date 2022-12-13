#!/usr/bin/python3
import sys
import math
from copy import deepcopy
from collections import defaultdict, deque
infile = sys.argv[1] 
data = open(infile).read().strip()
lines = [x for x in data.split('\n')]


def compare(left,right):
    if isinstance(left, list) and isinstance(right, list):
        i = 0
        while i<len(left) and i<len(right):
            c = compare(left[i], right[i])
            if c==-1:
                return -1
            if c==1:
                return 1
            i += 1
        if i==len(left) and i<len(right):
            return -1
        elif i==len(right) and i<len(left):
            return 1
        else:
            return 0
    elif isinstance(left, int) and isinstance(right, int):
        if left < right:
            return -1
        elif left == right:
            return 0
        else:
            return 1
    elif isinstance(left, int) and isinstance(right, list):
        return compare([left], right)
    else:
        return compare(left, [right])

packets = []
part1 = 0
for i,group in enumerate(data.split('\n\n')):
    left,right = group.split('\n')
    left = eval(left)
    right = eval(right)
    packets.append(left)
    packets.append(right)
    if compare(left, right)==-1:
        part1 += 1+i
print(part1)

packets.append([[2]])
packets.append([[6]])
from functools import cmp_to_key
packets = sorted(packets, key=cmp_to_key(lambda left,right: compare(left,right)))
part2 = 1
for i,p in enumerate(packets):
    if p==[[2]] or p==[[6]]:
        part2 *= i+1
print(part2)
