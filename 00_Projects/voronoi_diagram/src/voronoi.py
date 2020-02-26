import numpy as np
import cv2 as cv
import math

from geometry import Point
from image import Image

img_size = [600,800,3]
N = 10;

pts_set = []
[pts_set.append(Point.random(0,img_size[1]-1,0,img_size[0]-1)) for _ in range(0,N)]


img = Image(data = np.zeros(img_size),mode='color')

for pt in pts_set:
    img.data = cv.circle(img.data, (pt.x,pt.y), 4, (.85,.85,.85), -1)

dists = np.zeros((len(pts_set),1))

for l in range(0,img_size[0]):
    for c in range(0,img_size[1]):
        p = Point(c,l)
        for i in range(0,len(pts_set)):
            dists[i] = p.dist(pts_set[i],type = 'euclidean')
        img.data.itemset((l,c,2),np.argmin(dists)/len(pts_set))

img.show()
