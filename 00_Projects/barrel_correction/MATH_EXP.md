# MATH_EXP

## Common distortion formulas
In the equations which apply to several modules, r<sub>d</sub> is the distorted (measured) radius normalized to the center-to-corner distance. r<sub>u</sub> is the undistorted radius.

| | Distortion model | Formula |
|-|------------------|---------|
|1|3rd order|r<sub>u</sub> = r<sub>d</sub> + k<sub>1</sub>r<sub>d</sub><sup>3</sup>|
|2|5th order|r<sub>u</sub> = r<sub>d</sub> + k<sub>1</sub>r<sub>d</sub><sup>3</sup> +  k<sub>2</sub>r<sub>d</sub><sup>5</sup>|

*Link to the full [list](http://www.imatest.com/docs/distortion-methods-and-modules)*

The coefficient k<sub>1</sub>, at least for the first model of distortion, is directly related to the camera lens used to capture the image.

This [website](www.opticallimits.com) makes available the coefficient k<sub>1</sub> for a lot of common lenses.

## Creation of the x and y mapping arrays
This algorithm uses the 1st distortion model.
Let x' = x-w/2 and y' = y-h/2

- r<sub>d</sub> = (x'<sup>2</sup> + y'<sup>2</sup>)<sup>.5</sup>
- &theta; = tan<sup>-1</sup>(y/x)
- r<sub>u</sub> = r<sub>d</sub> (1 + k<sub>1</sub>r<sub>d</sub><sup>2</sup>)
- x<sub>u</sub> = r<sub>u</sub> cos(&theta;) + w/2
- y<sub>u</sub> = r<sub>u</sub> sin(&theta;) + h/2
- 2D interpolation using input image, x<sub>u</sub> and y<sub>u</sub>

This algorithm works, but can be quite slow, due to the square-root, arctan, cos, and sin computation.

## Optimization
With some mathematical manipulation, one can easily proove that we can get such equations :
- r<sub>d</sub><sup>2</sup> = x'<sup>2</sup> + y'<sup>2</sup>
- x<sub>u</sub> = (1 + k<sub>1</sub>r<sub>d</sub><sup>2</sup>)x' + w/2
- y<sub>u</sub> = (1 + k<sub>1</sub>r<sub>d</sub><sup>2</sup>)y' + h/2

These equations are faster to execute, and thus are used in `barrel_correction.py`
