function Snake() {
    this.x = width/2;
    this.y = height/2;
    this.xspeed = 0;
    this.yspeed = 0;

    this.total = 0;
    this.tail = [];

    this.dir = function(x, y) {
        this.xspeed = x;
        this.yspeed = y;
    }

    this.eat = function(pos) {
        var d = dist(this.x, this.y, pos.x, pos.y);
        if (d < 1)  {
            this.total++;
            return true;
        } else {
            return false;
        }
    }

    this.death = function() {
        for (var i = 0; i < this.tail.length; i++) {
            var pos = this.tail[i];
            var d = dist(this.x, this.y, pos.x, pos.y)
            if (d < 1) {
                this.initialize();
            }
        }
    }

    this.update = function() {
        for (var i = 0; i < this.tail.length - 1; i++) {
            this.tail[i] = this.tail[i + 1];
        }
        this.tail[this.total - 1] = createVector(this.x, this.y);

        if(this.x < 0) {
          this.x = this.x + width+scl;
        }
        if(this.y < 0){
          this.y = this.y + height+scl;
        }

        this.x = (this.x + this.xspeed * scl) % width;
        this.y = (this.y + this.yspeed * scl) % height;
    }

    this.show = function()  {
        fill(255);
        for (var i = 0; i < this.tail.length; i++) {
            rect(this.tail[i].x, this.tail[i].y, scl, scl);
        }
        rect(this.x, this.y, scl, scl);

    }

    this.initialize = function() {
      this.total = 0;
      this.tail = [];
      this.dir(0,0);
      this.x = width/2;
      this.y = height/2;
    }
}
