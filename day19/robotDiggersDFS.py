#!/usr/bin/python3
import re

def dfs(blueprint, maxes, cache, minute, robots, resources):
    if minute == 0:
        return resources[3]

    key = tuple([minute, *robots, *resources])
    if key in cache:
        return cache[key]

    maxResourceGain = resources[3] + robots[3]*minute

    for roboType, recipe in enumerate(blueprint):
        if roboType != 3 and robots[roboType] >= maxes[roboType]:
            continue

        wait = 0
        for resource, resourceType in recipe:
            if robots[resourceType] == 0:
                break
            wait = max(wait, -(-(resource - resources[resourceType]) // robots[resourceType]))
        else:
            timeLeft = minute - wait - 1
            if timeLeft <= 0:
                continue
            robots_ = robots[:]
            resources_ = [x + y * (wait + 1) for x, y in zip(resources, robots)]
            for resource, resourceType in recipe:
                resources_[resourceType] -= resource
            robots_[roboType] += 1
            for i in range(3):
                resources_[i] = min(resources_[i], maxes[i] * timeLeft)
            maxResourceGain = max(maxResourceGain, dfs(blueprint, maxes, cache, timeLeft, robots_, resources_))

    cache[key] = maxResourceGain
    return maxResourceGain

numGeode = 0

for i, line in enumerate(open(0)):
    blueprint = []
    maxes = [0,0,0]
    for section in line.split(": ")[1].split(". "):
        recipe = []
        for x, y in re.findall(r"(\d+) (\w+)", section):
            x = int(x)
            y = ["ore", "clay", "obsidian"].index(y)
            recipe.append((x, y))
            maxes[y] = max(maxes[y], x)
        blueprint.append(recipe)
    v = dfs(blueprint, maxes, {}, 24, [1, 0, 0, 0], [0, 0, 0, 0])
    numGeode += (i + 1) * v

print(numGeode)
