#!/usr/bin/python3
import sys
import time
import copy

infile = sys.argv[1] if len(sys.argv)>1 else 'input.txt'
numbers = open(infile).read().strip().split('\n')
numbers = [(i, int(num)) for i, num in enumerate(numbers)]
mixingOrder = copy.deepcopy(numbers)

maxIndex = len(numbers) - 1
for (i, num) in mixingOrder:
    index = numbers.index((i, num))
    newIndex = (index + num) % maxIndex
    numbers = numbers[:index] + numbers[index + 1:]
    numbers = numbers[:newIndex] + [(i, num)] + numbers[newIndex:]

values = [elem[1] for elem in numbers]

zeroIndex = values.index(0)
maxIndex += 1

index1 = (1000 + zeroIndex) % maxIndex
index2 = (2000 + zeroIndex) % maxIndex
index3 = (3000 + zeroIndex) % maxIndex

sumInd = values[index1] + values[index2] + values[index3]
print(sumInd)
