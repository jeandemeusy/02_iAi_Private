import numpy as np
import cv2 as cv
import argparse

import imutils
import matplotlib.pyplot as plt

from ImageClass import Image, strel_rect, strel_circle
from GeometricClass import Point

from line_reader import convert_image

def xget_blob_centers(img):
    cnts = cv.findContours(img, cv.RETR_EXTERNAL, cv.CHAIN_APPROX_SIMPLE)

    centers = []
    for c in imutils.grab_contours(cnts):
        M = cv.moments(c)
        cX = int(M["m10"] / M["m00"])
        cY = int(M["m01"] / M["m00"])
        centers.append([cX,cY])

    return centers

# ARGUMENT PARSER
text = "This program convert a single line score to a list of notes"
parser = argparse.ArgumentParser(description = text)
parser.add_argument("--file", default="/no_file", help="image to analyse")
args = parser.parse_args()


# IMAGE PROCESSING
img = Image(args.file)
bin =  img.invert().binarize(180)

lines = bin.close(strel_rect(1,10))

centers = xget_blob_centers(lines.data)
centers.sort(key = lambda x: x[1])
centers = np.array(centers)


notes = []
for c in centers:
    img2 = img.crop(Point(0,c[1]-50),Point(img.width,c[1]+50))
    notes.append(convert_image(img2,0))

print(notes)
