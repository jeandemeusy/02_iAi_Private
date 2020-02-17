import cv2 as cv
import numpy as np
import matplotlib.pyplot as plt
from scipy import stats
from scipy.signal import savgol_filter
from os import path

from math import atan2, pi

from FileClass import File

class Image:
    def __init__(self, file="", data=None):
        self.data = data
        self.file = File(file)

        if data is None and file:
            assert(path.exists(file))

            self.data = cv.imread(file, cv.IMREAD_GRAYSCALE)

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

    def mainContour(self, thres=127, linewidth=3):
        maxSize = 0;
        bin = self.binarize(thres)
        contours, hierarchy = cv.findContours(bin.data, \
                                cv.RETR_TREE, cv.CHAIN_APPROX_SIMPLE)
        for cont in contours:
            size = cv.contourArea(cont)
            if size > maxSize:
                maxSize = size
                maxCont = cont

        data = np.zeros(shape=self.shape, dtype=np.uint8)
        cv.drawContours(data, [maxCont], 0, 255, linewidth);

        return Image(data=data), maxCont

    def invert(self):
        return Image(data=cv.bitwise_not(self.data))

    def rotate(self,angle):
        self.data = cv.imrotate(self.data,angle)

    def crop(self, p1, p2):
        return Image(data=self.data[p1.y:p2.y, p1.x:p2.x])

    def warp(self, T):
        srcShape = np.float32(self.shape).reshape(-1, 1, 2)
        s = cv.perspectiveTransform(srcShape, T).reshape(2)

        return Image(data=cv.warpPerspective(self.data, T, (s[1], s[0])))

    def dilate(self, strel):
        return Image(data=cv.dilate(self.data, strel, 1))

    def erode(self, strel):
        return Image(data=cv.erode(self.data, strel, 1))

    def open(self,strel):
        return self.erode(strel).dilate(strel)

    def close(self,strel):
        return self.dilate(strel).erode(strel)

    def show(self, cmap="gray"):
        plt.imshow(self.data, cmap=cmap, vmin=0, vmax=255)
        plt.show()


def strel_rect(w,h):
    return cv.getStructuringElement(cv.MORPH_RECT, (w, h));

def strel_circle(r):
    return cv.getStructuringElement(cv.MORPH_ELLIPSE, (r, r))
