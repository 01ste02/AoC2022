#!/usr/bin/python3
import sys
import math
from collections import deque

infile = sys.argv[1] if len(sys.argv)>1 else 'input.txt'
rawValley = enumerate(open(infile).read().strip().split('\n')[1:])

blizzards = tuple(set() for _ in range(4))

for y, line in rawValley:
    for x, char in enumerate(line[1:]):
        if char in "<>^v":
            blizzards["<>^v".find(char)].add((y, x))

queue = deque([(0, -1, 0)])
seen = set()
target = (y, x - 1)

lcm = y * x // math.gcd(y, x)

while queue:
    time, currentY, currentX = queue.popleft()

    time += 1

    for deltaY, deltaX in ((0, 1), (0, -1), (-1, 0), (1, 0), (0, 0)):
            newY = currentY + deltaY
            newX = currentX + deltaX

            if (newY, newX) == target:
                print(time)
                exit(0)

            if (newY < 0 or newX < 0 or newY >= y or newX >= x) and not (newY, newX) == (-1, 0):
                continue

            for i, tryY, tryX in ((0, 0, -1), (1, 0, 1), (2, -1, 0), (3, 1, 0)):
                if ((newY - tryY * time) % y, (newX - tryX * time) % x) in blizzards[i]:
                    break
            else:
                key = (newY, newX, time % lcm)

                if key in seen:
                    continue

                seen.add(key)
                queue.append((time, newY, newX))

