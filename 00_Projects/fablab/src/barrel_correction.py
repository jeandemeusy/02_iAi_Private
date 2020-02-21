import numpy as np
import cv2 as cv
import scipy.io

from image import Image

# Functions
def load_mat_file(path,key='image'):
    mat = scipy.io.loadmat(path)
    return mat[key]


# Variables
k1 = -0.00925

# Input
im = Image("../assets/IMG_9065.jpg")
h, w = (im.height, im.width)

# Algorithm
x,y = np.meshgrid(np.arange(-w/2+1, w/2+1),np.arange(-h/2+1, h/2+1))

r_d2 = x**2 + y**2
max_r_d2 = np.amax(r_d2)

x_u = np.float32(np.multiply(1+r_d2*k1/max_r_d2,x) + w/2)
y_u = np.float32(np.multiply(1+r_d2*k1/max_r_d2,y) + h/2)

im_interp = cv.remap(im,x_u,y_u,cv.INTER_NEAREST)

C = Image(data=np.dstack((im_interp,im.data,im_interp))).show()
