var s;
var scl = 20;
var food;
var speed;

function setup() {
  createCanvas(600, 400);
  s = new Snake();
  pickLocation();
}

function pickLocation() {
  var cols = floor(width/scl);
  var rows = floor(height/scl);
  food = createVector(floor(random(cols)), floor(random(rows)));
  food.mult(scl);
}

function draw() {
  background(51);

  if(s.eat(food))
    pickLocation();

  s.death();
  s.update();
  s.show();

  fill(map(s.total,0,50,0,255),map(s.total,0,50,255,0),0);
  rect(food.x, food.y, scl, scl);
}

function keyPressed() {
  if(keyCode === UP_ARROW)
    s.dir(0, -1);
  else if (keyCode === DOWN_ARROW)
    s.dir(0, 1);
  else if (keyCode === RIGHT_ARROW)
    s.dir(1, 0);
  else if (keyCode === LEFT_ARROW)
    s.dir(-1, 0);
  else
    s.dir(0,0);

  speed = map(s.total, 0, 50, 8, 33);
  frameRate(speed);

}
