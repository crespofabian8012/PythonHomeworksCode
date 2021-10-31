# -*- coding: utf-8 -*-
"""
Created on Tue Oct 20 15:53:36 2015

@author: GOETHE
"""

import math
import random
def ArnoldCat(x,y):
    return [math.fmod(x+y,1),math.fmod(x+2*y,1)]
x0=random.random()
y0=random.random()
##print([x0,y0])
[x,y]=ArnoldCat(x0,y0)
eps=0.001
cont=1
while (math.pow((x-x0),2)+math.pow((y-y0),2) > math.pow(eps,2)):
    [x,y]=ArnoldCat(x,y)
    cont=cont+1

print("Punto inicial de la orbita")
print([x0,y0])
print("Punto de la orbita  a distancia menor del punto inicial que " +str(eps) )
print([x,y])
print("distancia "  )
print(math.pow((x-x0),2)+math.pow((y-y0),2))
print("No iteraciones "  )
print(cont)

    