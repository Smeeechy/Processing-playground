PImage img;
int factorIndex;
int[] factors;

void setup() {
  size(1366, 768);
  factorIndex = 0;
  factors = new int[]{1, 3, 5, 7, 15, 31, 63, 127};
}

void draw() {
  floydSteinbergDither("eye.png");
  atkinsonDither("eye.png");
}

void floydSteinbergDither(String imgUrl) {
  int factor = factors[factorIndex];
  img = loadImage(imgUrl);
  img.filter(GRAY);
  img.loadPixels();
  for (int y = 0; y < img.height; y++) {
    for (int x = 0; x < img.width; x++) {
      int index = index(x, y);
      color pixel = img.pixels[index];
      float r0 = red(pixel);
      float g0 = green(pixel);
      float b0 = blue(pixel);
      float r = round(factor * r0 / 255.0) * (255.0 / factor);
      float g = round(factor * g0 / 255.0) * (255.0 / factor);
      float b = round(factor * b0 / 255.0) * (255.0 / factor);
      img.pixels[index] = color(r, g, b);
      
      float rErr = r0 - r;
      float gErr = g0 - g;
      float bErr = b0 - b;
      int[] neighborIndeces = { /* pixel */   index(x + 1, y), 
        index(x - 1, y + 1), index(x, y + 1), index(x + 1, y + 1)};
      float[] errorFactors = {  /* pixel */   7 / 16.0, 
        3 / 16.0,            5 / 16.0,        1 / 16.0};
      for (int i = 0; i < neighborIndeces.length; i++) {
        int neighborIndex = neighborIndeces[i];
        if (neighborIndex < 0 || neighborIndex >= img.pixels.length) continue;
        float errorFactor = errorFactors[i];
        color neighbor = img.pixels[neighborIndex];
        float rN = red(neighbor) + (rErr * errorFactor);
        float gN = green(neighbor) + (gErr * errorFactor);
        float bN = blue(neighbor) + (bErr * errorFactor);
        img.pixels[neighborIndex] = color(rN, gN, bN);
      }
    }
  }
  img.updatePixels();
  //image(img, max(0, width/2 - img.width/2), max(0, height/2 - img.height/2)); 
  image(img, 0, 0);
}

/**
 * Works almost identical to Floyd-Steinberg. 
 * Only passes on 75% of the error, but spreads it evenly among more neighbors.
 */
void atkinsonDither(String imgUrl) {
  int factor = factors[factorIndex];
  img = loadImage(imgUrl);
  img.filter(GRAY);
  img.loadPixels();
  for (int y = 0; y < img.height; y++) {
    for (int x = 0; x < img.width; x++) {
      int index = index(x, y);
      color pixel = img.pixels[index];
      float r0 = red(pixel);
      float g0 = green(pixel);
      float b0 = blue(pixel);
      float r = round(factor * r0 / 255.0) * (255.0 / factor);
      float g = round(factor * g0 / 255.0) * (255.0 / factor);
      float b = round(factor * b0 / 255.0) * (255.0 / factor);
      img.pixels[index] = color(r, g, b);
      
      float rErr = r0 - r;
      float gErr = g0 - g;
      float bErr = b0 - b;
      int[] neighborIndeces = { /* pixel */   index(x+1, y), index(x+2, y), 
              index(x-1, y+1), index(x, y+1), index(x+1, y+1), 
                               index(x, y+2)};
      // unlike in floyd-steinberg, error factor is constant
      float errorFactor = 1 / 8.0;
      for (int i = 0; i < neighborIndeces.length; i++) {
        int neighborIndex = neighborIndeces[i];
        if (neighborIndex < 0 || neighborIndex >= img.pixels.length) continue;
        color neighbor = img.pixels[neighborIndex];
        float rN = red(neighbor) + (rErr * errorFactor);
        float gN = green(neighbor) + (gErr * errorFactor);
        float bN = blue(neighbor) + (bErr * errorFactor);
        img.pixels[neighborIndex] = color(rN, gN, bN);
      }
    }
  }
  img.updatePixels();
  //image(img, max(0, width/2 - img.width/2), max(0, height/2 - img.height/2));
  image(img, 690, 0);
}

int index(int x, int y) {
  return x + y * img.width; 
}

void mouseClicked() {
  if (factorIndex == factors.length - 1) factorIndex = 0;
  else factorIndex++;
}
