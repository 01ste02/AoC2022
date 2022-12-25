#!/usr/bin/python3
import sys
import time

infile = sys.argv[1] if len(sys.argv)>1 else 'input.txt'
rawValley = open(infile).read().strip().split('\n')

directions = { "<": (-1, 0), ">": (1, 0), "v": (0, 1), "^": (0, -1) }
expedition = []
blizzards = []
walls = []

x = 0
y = 0
for row in rawValley:
    x = 0
    for char in row:
        if y == 0 and char == ".":
            expedition = [x, y]
        elif char in directions.keys():
            blizzards.append([x, y, directions[char]])
        elif char == "#":
            walls.append((x, y))
        x += 1
    y += 1


maxY = y - 1
maxX = x - 1


def render():
    valleyMap = [["." for i in range(0, maxX + 1)] for j in range(0, maxY + 1)]
    for item in walls:
        valleyMap[item[1]][item[0]] = "#"
    for item in blizzards:
        valleyMap[item[1]][item[0]] = [key for key, value in directions.items() if value is item[2]][0]
    valleyMap[expedition[1]][expedition[0]] = "E"
    
    #for row in valleyMap:
    #    for char in row:
    #        print(char, end='')
    #    print("")
    return valleyMap

valleyMap = render()

target = ()
x = 0
for char in valleyMap[maxY]:
    if char == ".":
        target = [x, maxY]
    x += 1

def moveBlizzards():
    global blizzards
    global valleyMap
    for blizzard in blizzards:
        newPos = [blizzard[0] + blizzard[2][0],  blizzard[1] + blizzard[2][1], blizzard[2]]
        if valleyMap[newPos[1]][newPos[0]] == "#":
            if blizzard[2] == (-1, 0):
                newPos[0] = maxX - 1
            elif blizzard[2] == (1, 0):
                newPos[0] = 1
            elif blizzard[2] == (0, -1):
                newPos[1] = maxY - 1
            else:
                newPos[1] = 1
        blizzard[0] = newPos[0]
        blizzard[1] = newPos[1]
        blizzard[2] = newPos[2]
    valleyMap = render()

def moveExpedition():
    global valleyMap
    global expedition
    global directions
    for i in ['>', 'v', '^', '<']:
        x = expedition[0]
        y = expedition[1]
        direction = directions[i]
        if valleyMap[y + direction[1]][x + direction[0]] == ".":
            expedition[0] = x + direction[0]
            expedition[1] = y + direction[1]
            break


moves = 1
while not (expedition[0] == target[0] and expedition[1] == target[1]):
    print(moves)
    moveBlizzards()
    moveExpedition()
    valleyMap = render()
    moves += 1
    #time.sleep(0.2)
print(moves)

