import intel.pcsdk.*;

PXCUPipeline session;
Hands hands;

int columns = 8;
int rows = 8;

int padding = 10;

int diameter = 80;

int gridWidth = (diameter + padding) * columns;
int gridHeight = (diameter + padding) * columns;

Circles circles;

void setup() {
  session = new PXCUPipeline(this);
  session.Init(PXCUPipeline.GESTURE);
  hands = new Hands();

  size(gridWidth, gridHeight);

  circles = new Circles(rows, columns);

   for (int row = 0; row < rows; row++) {
    for (int column = 0; column < columns; column++) {

      int x = ((diameter + padding) * column) + ((padding + diameter) / 2);
      int y = ((diameter + padding) * row) + ((padding + diameter) / 2);

      circles.add(x,y);
    }
  }
}

void draw() {
  hands.update(session);

  background(255, 255, 255, 0);

  for (int i = 0;i<5;i++) {
    if (hands.primaryHand[i].x >0) {

      int touchedX = int(map(hands.primaryHand[i].x, 0, 320, 0, gridWidth));
      int touchedY = int(map(hands.primaryHand[i].y, 0, 320, 0, gridWidth));

      Circle circle = circles.findTouched(gridWidth - touchedX, touchedY);
      circle.touch(1);
    }
    if (hands.secondaryHand[i].x >0) {
      int touchedX = int(map(hands.secondaryHand[i].x, 0, 320, 0, gridWidth));
      int touchedY = int(map(hands.secondaryHand[i].y, 0, 320, 0, gridWidth));

      Circle circle = circles.findTouched(gridWidth - touchedX, touchedY);
      circle.touch(2);    
    }
  }

  for (int row = 0; row < rows; row++) {
    for (int column = 0; column < columns; column++) {
      Circle circle = circles.get(row,column);
      circle.draw();
    }
  }

  if (mousePressed) {
    hands.drawHands();
  }
}

class Circles {
  Circle circles[][];

  Circles(int rows, int columns) {
    circles = new Circle[rows][columns]; 
  }

  void add(int x, int y){
    circles[x][y] = new Circle(x, y);
  }

  Circle findTouched(float x, float y) {
    int column = int(x / ( diameter + padding ));
    int row = int(y / (diameter + padding));
    return get(row, column);
  }

  Circle get(int row, int column) {
    return circles[row][column];
  }
}

class Circle {

  int x;
  int y;

  boolean touched = false;
  int type;

  Circle(int tempX, int tempY) {
    x = tempX;
    y = tempY;
  }

  void draw() {

    if (touched == true) {
      if (type == 1) {
        stroke(255, 187, 51);
        fill(255, 187, 51);
      } else {
        stroke(170, 102, 204);
        fill(170, 102, 204); 
      }
   
    } else {
      stroke(255, 68, 68);
      fill(255, 68, 68);
    }

    ellipse(x, y, diameter, diameter);  

    reset();
  }

  void touch(int tempType) {
    touched = true;
    type = tempType;
  }

  void reset() {
    touched = false;
  }
}
