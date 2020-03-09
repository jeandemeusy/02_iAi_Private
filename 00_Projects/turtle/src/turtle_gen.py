import turtle

def square(turtle,size):
    rectangle(turtle,[size,size])

def rectangle(turtle,size):
    for _ in range(0,2):
        turtle.forward(size[0])
        turtle.left(90)
        turtle.forward(size[1])
        turtle.left(90)

side_poly = 64

turtle.shape("turtle")
turtle.speed(20)


for _ in range(0,side_poly):
    square(turtle,150)
    turtle.right(360/side_poly)

turtle.done()
