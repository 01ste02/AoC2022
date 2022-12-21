#!/usr/bin/python3
import sys
import time
import copy
import ast

infile = sys.argv[1] if len(sys.argv)>1 else 'input.txt'
lines = open(infile).read().strip().split('\n')

separators = "+-/*%"
translations = { }
operations = { }
for line in lines:
    item = line.split(': ')
    if not any(word in separators for word in line):
        translations[item[0]] = item[1]
    else:
        operations[item[0]] = item[1]

while operations:
    for key in list(operations):
        operation = operations[key]
        opVars = operation.split(' ')

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

print(translations["root"])
