float angle;
Table table;
float r = 200;
PImage earth;
PShape globe;

void setup() {
  size(600, 600, P3D);
  earth = loadImage("assets/earth.jpg");
  table = loadTable("http://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/2.5_month.csv", "header");
  noStroke();
  globe = createShape(SPHERE, r);
  globe.setTexture(earth);
}

void draw() {
  background(127);
  translate(width*0.5, height*0.5);
  rotateY(angle);
  angle += 0.005;

  lights();
  fill(200);
  noStroke();
  shape(globe);

  for (TableRow row : table.rows()) {
    float lat = row.getFloat("latitude");
    float lon = row.getFloat("longitude");
    float mag = row.getFloat("mag");

    float theta = radians(lat) + PI/2;
    float phi = radians(-lon) + PI;
    float x = r * sin(theta) * cos(phi);
    float y = r * cos(theta);
    float z = r * sin(theta) * sin(phi);
    PVector pos = new PVector(x, y, z);

    float h = pow(10, mag);
    float maxh = pow(10, 9);
    h = map(h, 0, maxh, 1, 10000);

    PVector xaxis = new PVector(1, 0, 0);
    float angleB = PVector.angleBetween(xaxis, pos);
    PVector raxis = xaxis.cross(pos);

    pushMatrix();
    translate(x, y, z);
    rotate(angleB, raxis.x, raxis.y, raxis.z);
    fill(255, 0, 100);
    box(h, 5, 5);
    popMatrix();
  }
}
