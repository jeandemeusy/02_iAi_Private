import numpy as np
import cv2 as cv
import scipy.io

from image import Image


# Functions
def load_mat_file(path,key='image'):
    mat = scipy.io.loadmat(path)
    return mat[key]
def radial_distortion_model(r_d, k):
    return np.add(r_d,k*np.power(r_d, 3))

# Variables
k1 = -0.00925

# Input
im = Image("../assets/IMG_9065.jpg")
# im = Image(data = data[0][1])
h,w = (im.height, im.width)

# # Algorithm
x,y = np.meshgrid(np.arange(-w/2+1, w/2+1),np.arange(-h/2+1, h/2+1))

r_d = np.sqrt(x**2 + y**2)
max_r = np.amax(r_d)

r_d = np.divide(r_d, max_r)
theta = np.arctan2(y,x)

r_u = radial_distortion_model(r_d, k1)

x_u = np.multiply(r_u,np.cos(theta)) * max_r + w/2
y_u = np.multiply(r_u,np.sin(theta)) * max_r + h/2

im_interp = cv.remap(im.data,np.float32(x_u),np.float32(y_u),cv.INTER_LINEAR)

C = Image(data=np.dstack((im_interp,im.data,im_interp))).show()
