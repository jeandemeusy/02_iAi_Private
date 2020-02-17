import numpy as np
import cv2 as cv
import argparse

import imutils
import matplotlib.pyplot as plt

from ImageClass import Image, strel_rect, strel_circle

notes_dict = {
    0: ["MI","E"],
    1: ["FA","F"],
    2: ["SOL","G"],
    3: ["LA","A"],
    4: ["SI","B"],
    5: ["DO","C"],
    6: ["RE","D"]
}
region_dict = {
    "EU": 0,
    "US": 1,
}

# FUNCTIONS
def xget_blob_centers(img):
    cnts = cv.findContours(img, cv.RETR_EXTERNAL, cv.CHAIN_APPROX_SIMPLE)

    centers = []
    for c in imutils.grab_contours(cnts):
        M = cv.moments(c)
        cX = int(M["m10"] / M["m00"])
        cY = int(M["m01"] / M["m00"])
        centers.append([cX,cY])

    return centers
def xpoint2dict(p, offset, step, dict):
    p_off = (np.array(p) - offset) / step
    p_off = np.round(p_off)
    return  np.mod(p_off, len(dict))


def convert_image(img,region_value):
    # IMAGE PROCESSING
    bin =  img.invert().binarize(180)

    notes = bin.open(strel_circle(6))
    stave = bin.open(strel_rect(25,1))


    # DATA EXTRACTION
    y_data = np.sum(stave.data,axis=1)
    y_lines = np.sort(y_data.argsort()[-5:][::-1])

    y_base = y_lines[-1]
    y_step = np.mean(np.diff(y_lines))

    centers = xget_blob_centers(notes.data)
    centers.sort()
    centers = centers[2:]

    # NOTE CONVERSION
    offset = [0, y_base]
    step = [1, -y_step/2]
    notes_idx = xpoint2dict(centers, offset, step, notes_dict)[:,1]

    #DISPLAY
    return [notes_dict.get(x,"ERR.")[region_value] for x in notes_idx]


if __name__ == "__main__":
    # ARGUMENT PARSER
    text = "This program convert a single line score to a list of notes"
    parser = argparse.ArgumentParser(description = text)
    parser.add_argument("--file", default="/no_file", help="image to analyse")
    parser.add_argument("--region", default="EU", help="display language")
    args = parser.parse_args()

    region_value = region_dict.get(args.region, 0)

    img = Image(args.file)

    notes = convert_image(img,region_value)

    print(notes)
