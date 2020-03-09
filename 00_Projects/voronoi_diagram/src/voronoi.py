import numpy as np
import cv2 as cv
import math

from geometry import Point
from image import Image

def index_to_color(index, range):
    base_color = index/range
    return [base_color, 0, 1-base_color]

H = 200
W = 500
N = 10;

pts_set = []
[pts_set.append(Point.random(0, W-1, 0, H-1)) for _ in range(0, N)]

img = Image(data = np.ones([H, W, 3]), mode='color')

dists = np.zeros((len(pts_set), 1))

for l in range(0, H):
    for c in range(0, W):
        for i in range(0, N):
            dists[i] = Point(c, l).dist(pts_set[i], type='euclidean')

        img.data[l, c] = index_to_color(np.argmin(dists), N)

for pt in pts_set:
    img.data = cv.circle(img.data, (pt.x, pt.y), 1, (.85, .85, .85), -1)

img.show()
