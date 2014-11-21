#!/usr/bin/python
import sys
import os
import fileinput
import math


# GLOBAL VARIABLES
N = 0
K = 0
EMPS = None
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
    return self.parent != 0

  def getParent(self):
    if self.hasParent() == 0:
      return None
    return EMPS[self.parent-1]

  def addChild(self, child):
    self.childs.append(child)

  def isLeaf(self):
    return not self.childs


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
      EMPS[i] = Employee(i, nums[1], nums[2])
      i = i + 1


def remove(index);
  global EMPS
  global TOTAL
  TOTAL = EMPS[index].totVal
  EMPS[index].totVal = 0

  i = index
  while i > 0:
    for child in EMPS[i].childs:
      EMPS[child].totVal =- EMPS[i].
    if(EMPS[i].hasParent()):
    


if __name__ == '__main__':
  global K
  readFile()


  while K > 0:
    for i in range(0, N):
      maxI = 0
      if(EMPS[N-1-i].isLeaf()):
        if EMPS[N-1-i].totVal > maxI:
          maxI = EMPS[N-1-i].index
    remove(maxI)
    K = K - 1

  print TOTAL 
