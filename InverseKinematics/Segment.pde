class Segment {
  PVector a;
  PVector b = new PVector();
  float len;
  float angle;
  Segment parent;
  Segment child = null;
  
  Segment(float x, float y, float len_, float angle_) {
    a = new PVector(x, y);
    len = len_;
    angle = angle_;
    calculateB();
  }
  
  Segment(Segment parent_, float len_, float angle_) {
    parent = parent_;
    a = parent.b.copy();
    len = len_;
    angle = angle_;
    calculateB();
  }
  
  void calculateB() {
    float dx = len * cos(angle);
    float dy = len * sin(angle);
    b.set(a.x + dx, a.y + dy);
  }
  
  void follow() {
    float targetX = child.a.x;
    float targetY = child.a.y;
    follow(targetX, targetY);
  }
  
  void follow(float targetX, float targetY) {
    PVector target = new PVector(targetX, targetY);
    PVector dir = PVector.sub(target, a);
    angle = dir.heading();
    
    dir.setMag(len);
    dir.mult(-1);
    a = PVector.add(target, dir);
  }
  
  void update() {
    calculateB();
  }
  
  void show() {
    stroke(255);
    strokeWeight(4);
    line(a.x, a.y, b.x, b.y);
  }
}
