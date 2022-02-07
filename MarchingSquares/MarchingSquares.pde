/*

 This uses a noise generator to assign a value between -1 and 1 to points on a grid.
 The number of points (and consequently, smoothness) depends on the resolution, but lower than ~20 really chugs on this machine.
 It then uses the marching squares algorithm and interpolates to draw borders at noise(x,y) = 0.
 
 */

OpenSimplexNoise noise;
float res = 5;
float zoom = 125;

float xoff = 0;
float yoff = 0;
float zoff = 0;

void setup() {
  //fullScreen(P2D);
  size(500, 500);
  noise = new OpenSimplexNoise();
  noStroke();
  fill(color(125, 200, 200, 50));
}

void draw() {
  background(color(25, 35, 45, 55));
  for (int col = 0; col < width; col+=res) {
    for (int row = 0; row < height; row+=res) {
      PVector nw = new PVector(col, row);
      PVector ne = new PVector(col + res, row);
      PVector se = new PVector(col + res, row + res);
      PVector sw = new PVector(col, row + res);
      PVector a = new PVector(interpX(nw, ne), nw.y);
      PVector b = new PVector(ne.x, interpY(ne, se));
      PVector c = new PVector(interpX(sw, se), sw.y);
      PVector d = new PVector(nw.x, interpY(nw, sw));

      switch(toBin(nw, ne, se, sw)) {
      case 1:
        triangle(c, sw, d);
        break;
      case 2:
        triangle(b, se, c);
        break;
      case 3:
        quad(b, se, sw, d);
        break;
      case 4:
        triangle(a, ne, b);
        break;
      case 5:
        triangle(a, ne, b);
        triangle(c, sw, d);
        break;
      case 6:
        quad(a, ne, se, c);
        break;
      case 7:
        beginShape();
        vertex(a);
        vertex(ne);
        vertex(se);
        vertex(sw);
        vertex(d);
        endShape(CLOSE);
        break;
      case 8:
        triangle(nw, a, d);
        break;
      case 9:
        quad(nw, a, c, sw);
        break;
      case 10:
        triangle(nw, a, d);
        triangle(b, se, c);
        break;
      case 11:
        beginShape();
        vertex(nw);
        vertex(a);
        vertex(b);
        vertex(se);
        vertex(sw);
        endShape(CLOSE);
        break;
      case 12:
        quad(nw, ne, b, d);
        break;
      case 13:
        beginShape();
        vertex(nw);
        vertex(ne);
        vertex(b);
        vertex(c);
        vertex(sw);
        endShape(CLOSE);
        break;
      case 14:
        beginShape();
        vertex(nw);
        vertex(ne);
        vertex(se);
        vertex(c);
        vertex(d);
        endShape(CLOSE);
        break;
      case 15:
        quad(nw, ne, se, sw);
        break;
      }
    }
  }
  //yoff += 1;
  zoff += .005;
}

void point(PVector p) {
  text(eval(p), p.x, p.y - 10);
  point(p.x, p.y);
}

void line(PVector p1, PVector p2) {
  line(p1.x, p1.y, p2.x, p2.y);
}

void triangle(PVector p1, PVector p2, PVector p3) {
  triangle(p1.x, p1.y, p2.x, p2.y, p3.x, p3.y);
}

void quad(PVector p1, PVector p2, PVector p3, PVector p4) {
  quad(p1.x, p1.y, p2.x, p2.y, p3.x, p3.y, p4.x, p4.y);
}

void vertex(PVector p) {
  vertex(p.x, p.y);
}

float eval(PVector p) {
  return (float) noise.eval((p.x + xoff) / zoom, (p.y + yoff) / zoom, zoff);
}

float interpX(PVector p1, PVector p2) {
  return (float) (p1.x + (p2.x - p1.x) * (-eval(p1)/(eval(p2) - eval(p1))));
}

float interpY(PVector p1, PVector p2) {
  return (float) (p1.y + (p2.y - p1.y) * (-eval(p1)/(eval(p2) - eval(p1))));
}

int toBin(PVector p1, PVector p2, PVector p3, PVector p4) {
  return (int) (ceil(eval(p1)) * 8 + ceil(eval(p2)) * 4 + ceil(eval(p3)) * 2 + ceil(eval(p4)));
}
