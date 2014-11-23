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
    self.leafs = []
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

  def addLeaf(self, leaf):
    self.leafs.append(leaf)

  def isLeaf(self):
    return not self.childs

# Priority Queue Class
class priorityQueue:
  def __init__(self):
    self.heap = []
    self.heap.append(-1)
    self.size = 0

  def heapifyUp(self, index):
    if index == 1:
      return
    print 'changing ' + str(self.heap[index]) + ' (' + str(EMPS[self.heap[index]].totVal) + '), > with ' + str(self.heap[index/2]) + ' (' + str(EMPS[self.heap[index/2]].totVal) +')'
    if EMPS[self.heap[index]].totVal > EMPS[self.heap[index/2]].totVal:
      print 'got in'
      temp = self.heap[index]
      self.heap[index] = self.heap[index/2]
      self.heap[index/2] = temp
      self.heapifyUp(index/2)

  def heapifyDown(self, index):
    if self.size < index*2:
      return
    if self.size < index*2+1:
      highChild = index*2
    elif EMPS[self.heap[index*2]].totVal > EMPS[self.heap[index*2+1]].totVal:
      highChild = index*2
    else:
      highChild = index*2+1

    print 'changing ' + str(self.heap[index]) + ' (' + str(EMPS[self.heap[index]].totVal) + '), < with ' + str(self.heap[highChild]) + ' (' + str(EMPS[self.heap[highChild]].totVal) +')'
    if EMPS[self.heap[index]].totVal < EMPS[self.heap[highChild]].totVal:
      print 'got in'
      temp = self.heap[index]
      self.heap[index] = self.heap[highChild]
      self.heap[highChild] = temp
      self.heapifyDown(highChild)


  def insert(self, i):
    self.heap.append(i)
    self.size = self.size + 1
    self.heapifyUp(self.size)

  def getMax(self):
    maxI = self.heap[1]
    maxVal = EMPS[self.heap[1]].totVal
    return maxI, maxVal

  def changeKey(self, index, value):
    if EMPS[self.heap[index]].totVal > value:
      EMPS[self.heap[index]].totVal = value
      self.heapifyDown(index)
    else:
      EMPS[self.heap[index]].totVal = value
      self.heapifyUp(index)

  def printVals(self):
      print self.heap


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

def addLeaf(index):
  i = index
  while EMPS[i].hasParent():
    EMPS[i].getParent().addLeaf(index)
    i = EMPS[i].parent
    
def changeLeafs(index):
  for leaf in EMPS[index].leafs:
    EMPS[leaf].totVal = EMPS[leaf].totVal - EMPS[index].value

def changeTot(index):
  i = index
  while EMPS[i].hasParent():
    changeLeafs(EMPS[i].parent)
    i = EMPS[i].parent

if __name__ == '__main__':
  readFile()
  LEAFS = priorityQueue()

  for emp in EMPS:
    if emp.isLeaf():
      addLeaf(emp.index)
      LEAFS.insert(emp.index)

  LEAFS.printVals()

  while K > 0:
    maxI, maxVal = LEAFS.getMax()
    print 'max val = ' + str(maxVal) + ', for index ' + str(maxI)
    changeTot(maxI)
    LEAFS.changeKey(1, 0)
    TOTAL = TOTAL + maxVal
    K = K - 1

  print TOTAL 
