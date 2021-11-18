# -*- coding: utf-8 -*-
"""
Created on Fri Jul 24 08:40:43 2015

@author: GOETHE
"""


from __future__ import division
from sympy import *

series(cos(x), x)
#1 - x**2/2 + x**4/24 + O(x**6)
series(1/cos(x), x)
#1 + x**2/2 + 5*x**4/24 + O(x**6)
dsolve(f(x).diff(x, x) + f(x), f(x))
#f(x) == C1*sin(x) + C2*cos(x)
dsolve(sin(x)*cos(f(x)) + cos(x)*sin(f(x))*f(x).diff(x), f(x), hint='separable')
#[f(x) == -asin(sqrt(C1/cos(x)**2 + 1)) + pi, f(x) == asin(sqrt(C1/cos(x)**2 + 1)) + pi, f(x) == -asin(sqrt(C1/cos(x)**2 + 1)), f(x) == asin(sqrt(C1/cos(x)**2 + 1))]
dsolve(x*f(x).diff(x) + f(x) - f(x)**2, f(x), hint='Bernoulli')
#f(x) == 1/(x*(C1 + 1/x))
eq = sin(x)*cos(f(x)) + cos(x)*sin(f(x))*f(x).diff(x)
dsolve(eq, hint='1st_exact')
#[f(x) == -acos(C1/cos(x)) + 2*pi, f(x) == acos(C1/cos(x))]
dsolve(eq, hint='almost_linear')
[f(x) == -acos(-sqrt(C1/cos(x)**2)) + 2*pi, f(x) == -acos(sqrt(C1/cos(x)**2)) + 2*pi, f(x) == acos(-sqrt(C1/cos(x)**2)), f(x) == acos(sqrt(C1/cos(x)**2))]

dsolve(f(x).diff(x, x) + f(x), f(x), hint='2nd_power_series_ordinary')
#f(x) == C1*x*(-x**2/6 + 1) + C0*(x**4/24 - x**2/2 + 1) + O(x**6)
dsolve(x*x*f(x).diff(x, 2) +x*f(x).diff(x,1)+(x*x-4/9) *f(x), f(x), hint='2nd_power_series_regular')
#f(x) == C0*(x**4/64 - x**2/4 + 1) + O(x**6)
