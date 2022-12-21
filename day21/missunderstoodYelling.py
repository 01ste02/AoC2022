#!/usr/bin/python3
import sys
import time
import copy
import ast
from sympy.abc import x
from sympy import solve
from sympy.parsing.sympy_parser import parse_expr

infile = sys.argv[1] if len(sys.argv)>1 else 'input.txt'
lines = open(infile).read().strip().split('\n')

separators = "+-/*%"
translations = { }
operations = { }
root = ""
for line in lines:
    item = line.split(': ')
    if item[0] == "root":
        tmp = item[1].split(' ')
        root = tmp[0] + " = " + tmp[2]
    elif item[0] == "humn":
        continue
    elif not any(word in separators for word in line):
        translations[item[0]] = item[1]
    else:
        operations[item[0]] = item[1]
dependsOnHuman = { }

while not all(key in dependsOnHuman for key in operations):
    for key in list(operations):
        operation = operations[key]
        opVars = operation.split(' ')
        
        if any(word == "humn" or word in dependsOnHuman for word in opVars):
            dependsOnHuman[key] = 1
        translatedOne = opVars[0].isdigit()
        translatedTwo = opVars[2].isdigit()

        if opVars[0] in translations:
            opVars[0] = translations[opVars[0]]
            translatedOne = 1

        if opVars[2] in translations:
            opVars[2] = translations[opVars[2]]
            translatedTwo = 1
    
        if translatedOne and translatedTwo:
            string = "".join(opVars)
            match opVars[1]:
                case "+": 
                    translations[key] = str(int(opVars[0]) + int(opVars[2]))
                case "-":
                    translations[key] = str(int(opVars[0]) - int(opVars[2]))
                case "/":
                    translations[key] = str(int(int(opVars[0]) / int(opVars[2])))
                case "*":
                    translations[key] = str(int(opVars[0]) * int(opVars[2]))
            del operations[key]
        else:
            operations[key] = " ".join(opVars)

def getStr(initString):
    if initString in operations:
        return getStr(operations[initString])
    else:
        op = initString.split(' ')
        if op[0] in operations:
            op[0] = getStr(operations[op[0]])
        if op[2] in operations:
            op[2] = getStr(operations[op[2]])
    return "(" + "".join(op) + ")"


operation = root.split(' ')
chooseTwo = 0
value = ""
if operation[0] in translations:
    value = translations[operation[0]]
    chooseTwo = 1
elif operation[2] in translations:
    value = translations[operation[2]]
    chooseTwo = 0

searchString = operation[0]
if chooseTwo:
    searchString = operation[2]

calcString = value + "-" + getStr(searchString).replace("humn", "x")
expr = parse_expr(calcString, evaluate=False)
print(solve(expr)[0])


    


