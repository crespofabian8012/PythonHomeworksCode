# -*- coding: utf-8 -*-
"""
Created on Mon Sep 07 09:24:22 2015

@author: GOETHE
"""

import numpy as np
import matplotlib.pyplot as plt


def f(x, lamda):
    return lamda*x*(1-x)


lamda=1.5
xactArray=[]
xact=0.001  
#xactArray.append(xact)

for i in range(100):
    xact=f(xact, lamda)
    xactArray.append(xact)
    

plt.plot(range(100),xactArray, 'r-')
plt.axis([0, 100, 0, 0.35])
plt.xlabel('iteraciones')
plt.ylabel('x ')
plt.title('Sistemas caoticos logisticos')


plt.grid(True)
plt.show()
################################################
lamdalist=np.arange(2.01,2.99,0.01).tolist()
xactArray=[]

for l in lamdalist:
   xant=0.01 
   xact=f(xant,l )
   while abs(xact-xant)>0.001:
      temp=xact
      xact=f(xact,l )
      xant=temp
   xactArray.append(xact) 

z=zip(lamdalist, xactArray)
plt.plot(lamdalist, xactArray, 'r-')
plt.axis([2, 3, 0.5, 0.7])
plt.xlabel('lambda')
plt.ylabel('punto fijo x')
plt.title('Sistemas caoticos logisticos')

plt.grid(True)
plt.show()
####################################################

lamdalist=np.arange(3.00,3.99,0.01).tolist()
xactArray=[]

for l in lamdalist:
    
    xact=0.01  
    xact=f(xact,l )
    for i in range(100):      
      xact=f(xact,l )
    xactArray.append(xact) 
print(xactArray)
  
z=zip(lamdalist, xactArray)
plt.plot(lamdalist, xactArray, 'r-')
plt.axis([3, 4, 0, 2])
plt.xlabel('lambda')
plt.ylabel('punto fijo x')
plt.title('Sistemas caoticos logisticos')


plt.grid(True)
plt.show()
