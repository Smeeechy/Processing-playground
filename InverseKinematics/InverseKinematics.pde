Segment tentacle;

float len = 5;
int numOfSegments = 500;
int factor = 10;

int x;
int y;

void setup() {
  size(1200, 800);
  
  x = int(random(width));
  y = int(random(height));
  
  Segment current = new Segment(300, 200, len, 0);
  
  for (int i = 0; i < numOfSegments; i++) {
    Segment next = new Segment(current, len, 0);
    current.child = next;
    current = next;
  }
  
  tentacle = current;
}

void draw() {
  background(51);
  strokeWeight(8);
  int dx = factor * int(floor(random(-1, 2)));
  int dy = factor * int(floor(random(-1, 2)));
  x = max(0, min(x + dx, width));
  y = max(0, min(y + dy, height));
  tentacle.follow(mouseX, mouseY);
  tentacle.update();
  Segment next = tentacle.parent;
  while (next != null) {
    next.follow();
    next.update();
    next.show();
    next = next.parent;
  }
}
