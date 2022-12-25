#!/usr/bin/python3
import sys
import math

infile = sys.argv[1] if len(sys.argv)>1 else 'input.txt'
snafu = open(infile).read().strip().split('\n')

totalSum = 0
for line in snafu:
    sum = 0
    exp = 1
    for char in line[::-1]:
        sum += ("=-012".find(char) - 2) * exp
        exp *= 5
    
    totalSum += sum

print(totalSum)

totalSNAFU = ""

while totalSum:
    place = totalSum % 5
    totalSum //= 5
    
    if place <= 2:
        totalSNAFU = str(place) + totalSNAFU
    elif place == 3:
        totalSNAFU = '=' + totalSNAFU
        totalSum += 1
    elif place == 4:
        totalSNAFU = '-' + totalSNAFU
        totalSum += 1

print(totalSNAFU)
