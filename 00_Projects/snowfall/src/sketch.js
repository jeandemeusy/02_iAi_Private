let snow = [];
let gravity;

let spritesheet;
let flakes = [];

function preload() {
    spritesheet = loadImage('../textures/flakes32.png');
}

function setup() {
    createCanvas(windowWidth*1.1, windowHeight*1.1);
    gravity = createVector(0, 0.03);

    for (x = 0; x < spritesheet.width; x += 32)
        for (y = 0; y < spritesheet.height; y += 32)
            flakes.push(spritesheet.get(x, y, 32, 32));

    for (i = 0; i < 600; i++)
        snow.push(new Snowflake(random(width), random(height), random(flakes)));
}

function draw() {
    background(0,43,100);
    for (flake of snow) {
        flake.applyForce(gravity);
        flake.update();
        flake.render();
    }
}
