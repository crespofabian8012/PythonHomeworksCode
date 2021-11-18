# -*- coding: utf-8 -*-
"""
Created on Tue Oct 06 21:14:19 2015

@author: GOETHE
"""

import numpy as np
import matplotlib.pyplot as plt
import pylab as pl
import math
n=5
cantorIntervals=[]
def  NCantorIntervalsBetweenXyY(x,y,n):
    if n == 0:
        return []
    interior_points = [2.*x/3. + y/3., x/3. + 2.*y/3.]
    return NCantorIntervalsBetweenXyY(x, interior_points[0], n-1) + interior_points + NCantorIntervalsBetweenXyY(interior_points[1], y, n-1)
def CantorIntervalsBetween0y1(n):
    return [0.] + NCantorIntervalsBetweenXyY(0., 1., n) + [1.]



h=0
for i in range(n):
    temp=CantorIntervalsBetween0y1(i)
    j=0
    while (j < len(temp)):
      plt.plot([temp[j],temp[j + 1]],[h,h], 'r-')
      j=j+2
    h=h+0.5

plt.axis([0, 1, -1, n / 2])
plt.xlabel('x')
plt.ylabel('Cantor intervals')

plt.grid(True)
plt.show()