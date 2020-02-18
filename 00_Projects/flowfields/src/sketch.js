var inc = 0.1;
var scl = 10;
var cols, rows;
var zoff = 0;
var fr;
var particles = [];
var flowfield;

function setup() {
    createCanvas(600, 600);
    //colorMode(HSB, 200);
    cols = floor(width / scl);
    rows = floor(height / scl);
    fr = createP('');

    flowfield = new Array(cols * rows);

    for (var i = 0; i < 2000; i++) {
        particles[i] = new Particle();
    }
    background(255);
}

function draw() {
    var yoff = 0;
    for (var y = 0; y < rows; y++) {
        var xoff = 0;
        for (var x = 0; x < cols; x++) {
            var index = x + y * cols;
            var angle = noise(xoff, yoff, zoff) * 2 * PI * 2;
            var v = p5.Vector.fromAngle(angle);
            v.setMag(3);
            flowfield[index] = v;
            xoff += inc;
        }
        yoff += inc;
        zoff += 0.0003;
    }
    for (var i = 0; i < particles.length; i++) {
        particles[i].follow(flowfield);
        particles[i].update();
        particles[i].edges();
        particles[i].show();
    }
}
