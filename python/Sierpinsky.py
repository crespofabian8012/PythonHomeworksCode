import numpy as np
import matplotlib.pyplot as plt
import pylab as pl
import math
import matplotlib.pyplot as plt
import matplotlib.patches as patches
def CircunscribedCircleAroundInverteddRegularTriangle(points):
  xCentro=points[2][0]
  yCentro=points[2][1]+(2.0 / 3.0)*(points[0][1]-points[2][1])
  radius =math.sqrt(math.pow((xCentro-points[2][0]),2)+math.pow((yCentro- points[2][1]), 2))
  return [[xCentro, yCentro], radius]
def CircunscribedCircleArounddRegularTriangle(points):
  xCentro=points[1][0]
  yCentro=points[0][1]+(1.0 / 3.0)*(points[1][1]-points[0][1])
  radius =math.sqrt(math.pow((xCentro-points[2][0]),2)+math.pow((yCentro- points[2][1]),2))
  return [[xCentro, yCentro], radius]
def f1(point):
  return [point[0] / 2.0, point[1] / 2.0]
def f2(point):
  return [(point[0] / 2.0)+ (1.0 / 2.0), point[1] / 2.0]
def f3(point):
  return [(point[0] / 2.0) + (1.0 / 2.0)* math.cos(math.pi / 3), (point[1] / 2.0)+(1.0 / 2.0)* math.sin(math.pi / 3)]
def GenerateSierpinskyTriangle(points,n, ax):
    if n == 0:
        return
    points_triangle1 = [points[0]]
    points_triangle1.append([(points[0][0] + points[1][0]) / 2, (points[0][1] + points[1][1]) / 2])
    points_triangle1.append([(points[0][0] + points[2][0]) / 2, (points[0][1] + points[2][1]) / 2])
    points_triangle2 = [points_triangle1[1]]
    points_triangle2.append(points[1])
    points_triangle2.append([(points[1][0] + points[2][0]) / 2, (points[1][1] + points[2][1]) / 2])
    points_triangle3 = [points_triangle1[2]]
    points_triangle3.append(points_triangle2[2])
    points_triangle3.append(points[2])
    points_center_triangle = [points_triangle1[1], points_triangle3[1], points_triangle1[2]]
    [center, radius] = CircunscribedCircleAroundInverteddRegularTriangle(points_center_triangle)

    #ax = fig.add_subplot(111, aspect='equal')
    ax.add_patch(
        patches.RegularPolygon(
            center,
            3,
            radius,
            math.pi,
            facecolor="white"
        )
    )
    GenerateSierpinskyTriangle(points_triangle1, n-1, ax)
    GenerateSierpinskyTriangle(points_triangle2, n-1, ax)
    GenerateSierpinskyTriangle(points_triangle3, n-1, ax)
def GenerateSierpinskyTriangle2(n, ax):
   GenerateSierpinskyTriangle([[0.0,0.0],[0.5, math.sqrt(3) / 2],[1.0,0.0]],n, ax)



if __name__ == '__main__':
    radius = math.sqrt(3) / 3
    #plt.ion()
    fig = plt.figure()
    ax = fig.add_subplot(111, aspect='equal')
    ax.add_patch(
        patches.RegularPolygon(
            (0.5, math.sqrt(3) / 6),
            3,
            radius,
            0,
            facecolor="blue"
        )
    )

    n = 9

    GenerateSierpinskyTriangle2(n, ax)
    plt.axis([0, 1, 0, 1])
    plt.xlabel('x')
    plt.ylabel('Triangulo Sierpinsky para n=' + str(n))
    plt.grid(True)
    plt.tight_layout()
    plt.show()