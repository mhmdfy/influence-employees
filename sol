#!/usr/bin/python
import sys
import os
import fileinput
import math


# GLOBAL VARIABLES
N = 0
K = 0
EMPS = []
LEAFS = []
TOTAL = 0

# Employee Class
class Employee:
  def __init__(self, index, parent, value):
    self.index = index
    self.value = value
    self.parent = parent
    self.childs = []
    if self.hasParent():
      self.totVal = value + self.getParent().getTotVal()
      self.getParent().addChild(self.index)
    else:
      self.totVal = self.value

  def getTotVal(self):
    return self.totVal

  def hasParent(self):
    return self.parent != -1

  def getParent(self):
    if not self.hasParent():
      return None
    return EMPS[self.parent]

  def addChild(self, child):
    self.childs.append(child)

  def isLeaf(self):
    return not self.childs

class priorityQueue:
  def __init__(self):
    heap = []

def readFile():
  global N
  global K
  global EMPS
  for line in fileinput.input():
    if(fileinput.isfirstline()):
      nums = [int(n) for n in line.split()]
      N = nums[0]
      K = nums[1]
      EMPS = [None] * N
      i = 0
    else:
      nums = [int(n) for n in line.split()]
      EMPS[i] = Employee(i, nums[1]-1, nums[2])
      i = i + 1

def modifyTot(i, val):
  EMPS[i].totVal = EMPS[i].totVal - val
  for child in EMPS[i].childs:
    modifyTot(child, val)

def changeTot(prev, index):
  oldVal = EMPS[index].totVal
  EMPS[index].totVal = 0
  for child in EMPS[index].childs:
    if child != prev:
      modifyTot(child, oldVal)
  if EMPS[index].hasParent():
    changeTot(index, EMPS[index].parent)

def remove(index):
  global TOTAL
  TOTAL = TOTAL + EMPS[index].totVal
  EMPS[index].totVal = 0
  changeTot(index, EMPS[index].parent)
    

if __name__ == '__main__':
  global K
  global LEAFS
  readFile()

  for emp in EMPS:
    if emp.isLeaf():
      LEAFS.append(emp.index)

  while K > 0:
    maxI = 0
    maxVal = 0
    for leaf in LEAFS:
      if EMPS[leaf].totVal > maxVal:
        maxVal = EMPS[leaf].totVal
        maxI = leaf
    remove(maxI)
    K = K - 1

  print TOTAL 
