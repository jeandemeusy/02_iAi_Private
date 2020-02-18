ArrayList<Circle> circles;
PImage img;

void setup() {
  size(900, 400);
  img = loadImage("assets/batman.png");
  img.loadPixels();
  circles = new ArrayList<Circle>();
}

void draw() {
  background(255);
  
  int total = 20;
  int count = 0;
  int attemps = 0;
  
  while (count < total) {
    Circle newC = newCircle();
    if (newC != null) {
      circles.add(newC);
      count++;
    }
    attemps++;
    if (attemps > 1000) {
      noLoop();
      break;
    }
  }

  for (Circle c : circles) {
    if (c.growing){
      if (c.edges())
        c.growing = false;
      else
        for (Circle other : circles) {
          if (c != other) {
            float d = dist(c.x, c.y, other.x, other.y);
            if (d - 1 < c.r + other.r) {
              c.growing = false;
              break;
            }
          }
        }
    }
    c.show();
    c.grow();
  }
}

Circle newCircle() {  
  float x = random(width);
  float y = random(height);
  
  boolean valid = true;
  
  for (Circle c : circles) {
    float d = dist(x,y,c.x,c.y);
    if(d < c.r + 5) {
      valid = false;
      break;
    }
  }
  
  if (valid) {
    int index = int(x) + int(y) * img.width;
    color col = img.pixels[index];
    return new Circle(x,y,col);
  }
  else
    return null;
}
