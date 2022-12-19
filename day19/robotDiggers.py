#!/usr/bin/python3
import sys
import math
import time
from copy import deepcopy

infile = sys.argv[1] if len(sys.argv)>1 else 'input.txt'
blueprints = open(infile).read().strip()
blueprints = blueprints.split('\n')
blueprints = [blueprint.split(': ')[1] for blueprint in blueprints]

robotBlueprints = {}

for bInd in range(len(blueprints)):
    #print(blueprints[bInd])
    blueprint = blueprints[bInd]
    robotList = {}
    for item in blueprint.split('. '):
        #print(item)
        line = item.split(' ')

        if len(line) > 6:
            del line[6]
        
        costs = {}
        for i in range(4, len(line) - 1, 2):
            #print("TEST", line[i], line[i+1])
            costs[line[i+1].replace('.', '')] = int(line[i])

        robotList[line[1]] =  costs

        #print("Key:", line[1], "Value:")

    robotBlueprints[bInd] = robotList
    #print("New")
    print(robotBlueprints[bInd])

bInd = 1
numGeodes = {}
for index in robotBlueprints:
    blueprint = robotBlueprints[index]

    minute = 1
    resources = {item: 0 for item in ["ore", "clay", "obsidian", "geode"]}

    robots = {item: 0 for item in ["ore", "clay", "obsidian", "geode"]}
    robots["ore"] = 1
    building = ""
    maxes = {item: 0 for item in resources}
    for robot in blueprint:
        for resource in blueprint[robot]:
            maxes[resource] = max(maxes[resource], blueprint[robot][resource])

    print(maxes)
    while minute <= 24:
        maxSum = 0
        maxRobots = 0
        for turn in range(24-minute):
            maxRobots += 1
            maxSum += maxRobots
        if (resources["obsidian"] + robots["obsidian"] * (24-minute) + maxSum) > blueprint["geode"]["obsidian"] and minute != 24:
            print((blueprint["obsidian"]["ore"] / robots["ore"]) > ((blueprint["obsidian"]["clay"] - resources["clay"]) / robots["clay"] if robots["clay"] > 0 else 1000000000))
            if resources["obsidian"] + robots["obsidian"] >= blueprint["geode"]["obsidian"]:
                print("minute", minute, end=" ")
                print("saving for geode")
                if resources["obsidian"] >= blueprint["geode"]["obsidian"] and resources["ore"] >= blueprint["geode"]["ore"]:
                    building = "geode"
                    print("minute", minute, end=" ")
                    print("geode")
            elif resources["clay"] + robots["clay"] >= blueprint["obsidian"]["clay"] or (blueprint["obsidian"]["ore"] / robots["ore"]) > ((blueprint["obsidian"]["clay"] - resources["clay"]) / robots["clay"] if robots["clay"] > 0 else 1000000000):
                print("minute", minute, end=" ")
                print("saving for obsidian")
                if resources["clay"] >= blueprint["obsidian"]["clay"] and resources["ore"] >= blueprint["obsidian"]["ore"]:
                    building = "obsidian"
                    print("minute", minute, end=" ")
                    print("obsidian")
            elif resources["ore"] + robots["ore"] >= blueprint["clay"]["ore"]:
                print("minute", minute, end=" ")
                print("saving for clay")
                if resources["ore"] >= blueprint["clay"]["ore"]:
                    print("minute", minute, end=" ")
                    print("clay")
                    building = "clay"
            elif resources["ore"] >= blueprint["ore"]["ore"]:
                print("minute", minute, end=" ")
                print("ore")
                building = "ore"
            
        for key in robots:
            resources[key] += robots[key]

        if building != "":
            robots[building] += 1
            for resource in blueprint[building]:
                resources[resource] -= blueprint[building][resource]
            building = ""
        print("Time:", minute, "Robots:", robots, "Resources:", resources)
        minute += 1
    numGeodes[bInd] = resources["geode"]
    bInd += 1

print(numGeodes)
