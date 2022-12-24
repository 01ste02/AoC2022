#!/usr/bin/python3
import sys

infile = sys.argv[1] if len(sys.argv)>1 else 'input.txt'
y = 10 if len(sys.argv)>1 else 2000000
limit = int(21) if len(sys.argv)>1 else (int(4e6) + 1)

lines = open(infile).read().strip().split('\n')

sensors = {}
beacons = {}

for line in lines:
    coordinates = line.replace('Sensor at ', '').replace(' closest beacon is at ', '').split(':')
    (sX, sY), (bX, bY) = [coord.replace('x=','').replace('y=', '').split(', ') for coord in coordinates]
    dist = (abs(int(sX) - int(bX)) + abs(int(sY) - int(bY)))
    sensors[(int(sX), int(sY), dist)] = ""
    beacons[(int(bX), int(bY))] = ""

for y in range(0, limit):
    ranges = []
    for (sX, sY, dist) in sensors:
        dL = dist - abs(y - sY)
        if dL >= 0:
            ranges.append((sX - dL, sX + dL + 1))
    stopped = 0
    for low, high in sorted(ranges):
        if low > stopped:
            print(stopped * 4000000 + y)
        stopped = max(stopped,high)

