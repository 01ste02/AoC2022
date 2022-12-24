#!/usr/bin/python3
import sys

infile = sys.argv[1] if len(sys.argv)>1 else 'input.txt'
y = 10 if len(sys.argv)>1 else 2000000
limit = int(100) if len(sys.argv)>1 else int(5e6)

lines = open(infile).read().strip().split('\n')

sensors = []
beacons = {}

for line in lines:
    coordinates = line.replace('Sensor at ', '').replace(' closest beacon is at ', '').split(':')
    (sX, sY), (bX, bY) = [coord.replace('x=','').replace('y=', '').split(', ') for coord in coordinates]
       
    sensors.append((int(sX), int(sY), abs(int(sX) - int(bX)) + abs(int(sY) - int(bY))))
    beacons[(int(bX), int(bY))] = ""

numImpossible = 0
for x in range(int(-limit), int(limit)):
    for (sX, sY, dist) in sensors:
        if (abs(sX - x) + abs(sY - y)) <= dist:
            if (x, y) not in beacons:
                numImpossible += 1
            break

print(numImpossible)
