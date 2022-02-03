OpenSimplexNoise noise;

int xskip = 5;
int yskip = 5;
int zskip = 1;
int z = 0;

void setup() {
  noise = new OpenSimplexNoise();
  size(1280, 640);
}

void draw() {
  background(255);
  stroke(0);
  for (int x = 0; x < width; x += xskip) {
    for (int y = 0; y < height; y += yskip) {
      float noiseVal = noise(x, y, z);
      strokeWeight(noiseVal * 5);
      point(x, y);
    }
  }
  z += zskip;
}
