float z = 0;

void setup() {
  size(600, 400);
}

void draw() {
  background(255);
  fill(0);
  //strokeWeight(mouseX/max(mouseY, 0.01));
  //point(mouseX, mouseY);
  for (int x = 0; x <= width; x += 20) {
    for (int y = 0; y <= height; y += 20) {
      strokeWeight((x + y)/(35*sin(z) + 35));
      point(x, y);
    }
  }
  z += .05;
}
