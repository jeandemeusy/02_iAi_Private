var xoff = 0;
var yoff = 0;
var dx = 0.1;

function setup() {
    createCanvas(400, 400);
}

function draw() {
    background(51);
    translate(width/2, height/2);

    stroke(255);
    fill(255,50);
    strokeWeight(1);
    beginShape();
    for(var a = -PI/2; a <= 3*PI/2; a+= PI/100) {
      var n = noise(xoff);
      var r = sin(2 * a) * map(n,0,1,50,100);
      var x = r * sin(a)*sin(frameCount*0.1);
      var y = r * cos(a);
      xoff += (a <= PI/2) ? dx : -dx;
      vertex(x,y);
      yoff += 0.0004;
    }
    endShape();
}
