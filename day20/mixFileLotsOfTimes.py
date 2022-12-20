#!/usr/bin/python3
import sys
import time
import copy

decryptionKey = 811589153

infile = sys.argv[1] if len(sys.argv)>1 else 'input.txt'
numbers = open(infile).read().strip().split('\n')
numbers = [(i, int(num) * decryptionKey) for i, num in enumerate(numbers)]
mixingOrder = copy.deepcopy(numbers)

maxIndex = len(numbers) - 1

def mixNumbers(nums, mixOrder):
    for (i, num) in mixOrder:
        index = nums.index((i, num))
        newIndex = (index + num) % maxIndex
        nums = nums[:index] + nums[index + 1:]
        nums = nums[:newIndex] + [(i, num)] + nums[newIndex:]
    return nums

for _ in range(10):
    numbers = mixNumbers(numbers, mixingOrder)

values = [elem[1] for elem in numbers]

zeroIndex = values.index(0)
maxIndex += 1

index1 = (1000 + zeroIndex) % maxIndex
index2 = (2000 + zeroIndex) % maxIndex
index3 = (3000 + zeroIndex) % maxIndex

sumInd = values[index1] + values[index2] + values[index3]
print(sumInd)
