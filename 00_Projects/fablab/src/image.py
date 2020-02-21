import cv2 as cv
import numpy as np
import matplotlib.pyplot as plt
from scipy import stats
from scipy.signal import savgol_filter
from os import path

from math import atan2, pi

from geometry import Point, Line, rotate
from file import File

class Image:
    def __init__(self, file="", data=None):
        self.file = File(file)

        if data is None and file:
            assert(path.exists(file))
            self.data = cv.imread(file, cv.IMREAD_GRAYSCALE)
        elif data.ndim == 3:
            self.data = cv.cvtColor(data, cv.COLOR_BGR2GRAY)
        else:
            self.data = data

    def __repr__(self):
        return 'Image: {width:' + str(self.width) + \
                ', height:' + str(self.height) + '}'

    @property
    def width(self):
        return self.shape[1]

    @property
    def height(self):
        return self.shape[0]

    @property
    def shape(self):
        return self.data.shape

    def binarize(self,thrs=127):
        _, data = cv.threshold(self.data, thrs, 255, \
                    cv.THRESH_BINARY + cv.THRESH_OTSU)
        return Image(data = data);

    def invert(self):
        return Image(data=cv.bitwise_not(self.data))

    def rotate(self,angle):
        self.data = cv.imrotate(self.data,angle)

    def crop(self, p1, p2):
        return Image(data=self.data[p1.y:p2.y, p1.x:p2.x])

    def warp(self, tform):
        src_shape = np.float32(self.shape).reshape(-1, 1, 2)
        s = cv.perspectiveTransform(src_shape, tform).reshape(2)

        return Image(data=cv.warpPerspective(self.data, tform, (s[1], s[0])))

    def dilate(self, s):
        strel = cv.getStructuringElement(cv.MORPH_ELLIPSE, (s, s))
        return Image(data=cv.dilate(self.data, strel, 1))

    def erode(self, s):
        strel = cv.getStructuringElement(cv.MORPH_ELLIPSE, (s, s))
        return Image(data=cv.erode(self.data, strel, 1))

    def open(self,s):
        return self.erode(s).dilate(s)

    def close(self,s):
        return self.dilate(s).erode(s)

    def show(self, cmap="gray", vmin=None, vmax=None):
        if vmin is None:
            vmin = np.amin(self.data)
        if vmax is None:
            vmax = np.amax(self.data)
        plt.imshow(self.data, cmap=cmap, vmin=vmin, vmax=vmax)
        plt.show()
