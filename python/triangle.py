# -*- coding: utf-8 -*-
"""
Created on Wed Oct 01 22:01:18 2014

@author: Fausto Fabian Crespo Fernandez
00123688
"""

import sys
import numpy as np
from numpy import array
import matplotlib
import matplotlib.pyplot as plt
from matplotlib.path import Path
import mpl_toolkits.mplot3d as a3
import matplotlib.patches as patches
import matplotlib.colors as colors
import pylab as pl
import math
import os
import time
import random
import itertools

class point:

	def __init__(self,x=array([0,0,0])):
		self.x=x
	def __repr__(self):
		return 'p:'+str(self.x)
	def __getitem__(self,i):
		if i<3 and i>-1:
			return self.x[i]
		print 'point::__getitem__('+str(i)+') fuera de rango.'
		exit()
	def __eq__(self,other):
		if (self[0] == other[0] and self[1] == other[1] and self[2] == other[2]):
			return True
		else: return False
	def __neg__(self):
		return point(-self.x)
	def __add__(self,other): 
		return point(self.x+other.x)
	def __iadd__(self,other): 
		return point(self.x+other.x)
	def __sub__(self,other): 
		return point(self.x-other.x)
	def __mul__(self,scalar):
		return point(scalar*self.x)
	def __rmul__(self,scalar):
		return point(scalar*self.x)
	def __div__(self,scalar):
		return point(self.x/scalar)
	def __idiv__(self,scalar):
		return point(self.x/scalar)
	def cross(self,other):
		return point(np.cross(self.x,other.x))
	def mag(self):
		return math.sqrt(np.inner(self.x,self.x))
	def makeUnit(self):
		self.x = self.x/self.mag()
	
class edge:
	# 2 puntos , vector entre ellos y si esta en la superficie
	def __init__(self,p1=point(),p2=point(),inSurf=False):
		self.p1=p1
		self.p2=p2
		self.v = p2-p1
		self.inSurf=inSurf
	def __repr__(self):
		return '['+str(self.p1)+'] ['+str(self.p2)+']\n['+str(self.v)+'] '+str(self.inSurf)
	def __getitem__(self,i):
		if i==0:
			return self.p1
		if i==1:
			return self.p2
		print 'edge::__getitem__('+str(i)+') fuera de rango.'
		exit()
	def __eq__(self,other):
		if self[0] == other[0] and self[1] == other[1]:
			return True
		elif self[0] == other[1] and self[1] == other[0]:
			return True
		return False
	
	def hasPoint(self,p):
		if self[0]==p or self[1]==p: return True
		return False
	
	# retorna vector normal para triangulo incluyendo oP
	def findNormal(self,oP):
		dV = oP - self[0]
		return self.v.cross(dV)/(self.v.mag()*dV.mag())

# triangulo en 3d
class tri:
	def __init__(self,oP1=point(),oP2=point(),oP3=point()):
	# tres puntos
		self.p = (oP1,oP2,oP3)  
	# tres aristas
		self.e = (edge(self.p[0],self.p[1]),edge(self.p[1],self.p[2]),edge(self.p[2],self.p[0]))
	# vector normal
		self.n = (self.p[1]-self.p[0]).cross(self.p[2]-self.p[0])
	# centro
		self.c = (oP1+oP2+oP3)/3.
	def __repr__(self):	
		return str(self.e[0])+',\n'+str(self.e[1])+',\n'+str(self.e[2])+'\n'+str(self.n)
		
	
	# retorna verdadero si triangulo contiene  punto p
	def hasPoint(self,oP):
		for mP in self.p:
			if mP == oP:
				return True
		return False
		
	# retorna verdadero si contiene arista e
	def hasEdge(self,oE):
		for edge in self.e:
			if edge == oE:
				return True
		return False
	
	# retorna verdadero si triangulo contiene arista e r
	# y marca la arista como que pertenece a la superficie
	def markEdge(self,oE):
		for edge in self.e:
			if edge == oE:
				edge.inSurf = True
				return True
		return False
	
	# retorna primera arista no conectada
	def minDisc(self):
		for edge in self.e:
			if not edge.inSurf:
				return (True,edge)
		return (False,self.e[0])
	
	def __eq__(self,other):
		if other.hasPoint(self.p[0]) and other.hasPoint(self.p[1]) and other.hasPoint(self.p[2]):
			return True
		return False

	def getTri(self):
		pS = array([[self.p[0][0],self.p[0][1],self.p[0][2]],
				    [self.p[1][0],self.p[1][1],self.p[1][2]],
				    [self.p[2][0],self.p[2][1],self.p[2][2]]])
		return pS
		
	def fixN(self,center):
		#print self.n.x, self.c.x, center.x
		if np.inner(self.n.x, self.c.x - center.x) < 0:
			self.n = -self.n

def findCenter(points):
	c = point()
	for p in points:
		c+=p
	c /= len(points)
	#print 'center: ',c
	return c

def plotPoints2(points):
	
	fig = plt.figure()
	ax = fig.add_subplot(111)
	
	x = []
	y = []
	for p in points:
		x.append(p[0])
		y.append(p[1])
	
	plt.plot(x,y,'bo')
	ax.set_xlim(0,1)
	ax.set_ylim(0,1)
	plt.show()

	del(x)
	del(y)

def plotPoints(points):
	
	fig = plt.figure()
	ax = fig.add_subplot(111, projection='3d')
	
	x = []
	y = []
	z = []
	for p in points:
		x.append(p[0])
		y.append(p[1])
		z.append(p[2])

	ax.scatter(x,y,z)
	ax.set_xlim(0,1)
	ax.set_ylim(0,1)
	ax.set_zlim(0,1)

	ax.set_xlabel('x')
	ax.set_ylabel('y')
	ax.set_zlabel('z')

	plt.show()
	
	
	del(x)
	del(y)
	del(z)

def plotSurf(surf,points):
	ax = a3.Axes3D(pl.figure())
	
	for t in surf:
		vtx = t.getTri()
		#print vtx
		tri = a3.art3d.Poly3DCollection([vtx])
		tri.set_color(colors.rgb2hex(np.random.rand(3)))
		tri.set_edgecolor('k')
		ax.add_collection3d(tri)
		
	x = []
	y = []
	z = []
	for p in points:
		x.append(p[0])
		y.append(p[1])
		z.append(p[2])

	ax.scatter(x,y,z)
	ax.set_xlim(0,1)
	ax.set_ylim(0,1)
	ax.set_zlim(0,1)	
	
	pl.show()
	
	del(x)
	del(y)
	del(z)

def isOpen(surf):
	for t in surf:
		if (not t.e[0].inSurf) or (not t.e[1].inSurf) or (not t.e[2].inSurf):
			return True
	return False

def markEdges(surf):
	for mE in surf[-1].e:
		for t in surf:
			if t == surf[-1]: 
				break
			if t.markEdge(mE):
				mE.inSurf = True

# entra lista de puntos  en 3d
# devuelve lista de triangulos 
# que estan en la envoltura convexa
def giftWrap(points):
	
	# lista de triangulos de la envoltura convexa
	surf = []  
	
	center = findCenter(points)
	
	# hallar el primer punto
	# con min(x[0])
	points.sort(key=lambda tup:tup[0]) 
	p1 = points[0]
	#print 'p1 ',p1

	#hallar segundo punto
	# con angulo minimo con y 
	maxDot = -1.
	p2 = point()
	for mP in points:
		if mP == p1: continue

		delta = mP-p1
		delta.makeUnit()
		dDot = np.inner(delta.x,array([0,1,0]))

		#print delta, dDot
		if maxDot < dDot:
			maxDot = dDot
			p2 = mP
	
	#print 'p2 ',p2
	plotPoints2(points)
	
	e1 = edge(p1,p2)
	#print 'e1 :',e1
	
	# hallar primera arista no agregada en surf
	# necesita tri, edge, y vector normal 
	maxDot = -2
	p3 = point()
	for p in points:
		if e1.hasPoint(p): continue
		mN = e1.findNormal(p)
		if np.inner(mN.x,center.x) < 0: mN = -mN
		dDot = np.inner(mN.x,array([-1,0,0]))
		if maxDot < dDot:
			maxDot = dDot
			p3 = p
	
	surf.append(tri(p1,p2,p3))
	surf[-1].fixN(center)
	
	#print 'surf[0]'
	#print surf[0]
	
	#plotSurf(surf,points)
	
	# buscar puntos que no estan en tri
	# y que tengan  producto punto maximo: dot(tri.normal(),newTri.normal())
	while isOpen(surf):
		maxDot = -2
		mE = edge()
		for t in surf:
			(status,mE) = t.minDisc()
			if not status: continue
			#print 'mE = ',mE
			
			# hallar p con maximo dot
			for p in points:
				if t.hasPoint(p): continue
				mN = mE.findNormal(p)
				dDot = np.inner(mN.x,t.n.x)
				if maxDot < dDot:
					maxDot = dDot
					p3 = p
					
			# crear y adicionar nuevo triangulo	
			surf.append(tri(mE[0],mE[1],p3))
			surf[-1].fixN(center)
			
			# marcar arista as la union de ambos triangulos
			markEdges(surf)
			
			#plotSurf(surf,points)
			# empezar desde arriba
			break
		
		#print 'surf[-1]'
		#print surf[-1]
		
	return surf
	
# genera lista de puntos
# para la cual calculamos el area
def genPoints():
	points = []
	shapeSize = random.randint(5,6)
	for i in range(shapeSize):
		points.append(point(array([random.triangular(),random.triangular(),random.triangular()])))
	return points
	
def main():

	points = genPoints()
	print 'points:'
	for p in points:
		print p
		
	plotPoints(points)
	surf = giftWrap(points)
	
	plotSurf(surf,points)
	
	return
	
if __name__ == '__main__':
	main()