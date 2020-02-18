function getRandomSize() {
    let r = pow(random(0, 1), 2);
    return constrain(r * 44, 6, 44);
}

class Snowflake {
    constructor(sx, sy, texture) {
        let x = sx || random(width);
        let y = sy || random(-100, -10);
        this.texture = texture;
        this.pos = createVector(x, y);
        this.vel = createVector(0, 0);
        this.acc = createVector();
        this.angle = random(TWO_PI);
        this.dir = (random(1) > 0.5) ? 1 : -1;
        this.r = getRandomSize();
    }

    applyForce(force) {
        let f = force.copy();
        f.mult(this.r);
        this.acc.add(f);
    }

    randomize() {
        let x = random(width);
        let y = random(-100, -10);
        this.pos = createVector(x, y);
        this.vel = createVector(0, 0);
        this.acc = createVector();
        this.xOff = 0;
        this.r = getRandomSize();
    }

    update() {
        this.xOff = sin(this.angle) * this.r;
        this.vel.add(this.acc);
        this.vel.limit(this.r * 0.1)

        if (this.vel.mag() < 1)
            this.vel.normalize();

        this.pos.add(this.vel);
        this.acc.mult(0);

        if (this.pos.y > height + this.r)
            this.randomize();
    }

    render() {
        push();
        translate(this.pos.x + this.xOff, this.pos.y);
        rotate(this.angle);
        imageMode(CENTER);
        image(this.texture, 0, 0, this.r, this.r);
        pop();

        this.angle += this.dir * this.vel.mag() * 0.01;
    }

    offScreen() {
        return (this.pos.y > height + this.r);
    }
}
