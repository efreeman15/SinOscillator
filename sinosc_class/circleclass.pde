class Circle {
  PVector pos;
  int index;
  float cModifier;
  float red, green, blue;
  int circSize = 20;


  Circle (PVector _pos, int _counter) {
    pos = _pos;
    index = _counter;
  }

  void createCircle() {
    circles.add(new Circle(new PVector(mouseX, mouseY), counter));
  }

  void update() {
    cModifier = (height/2 - pos.y);
  }

  void display() {
    noStroke();
    red = map(pos.x, 0, width + 50, 0, 255);
    green = map(pos.y, 0, height + 50, 0, 255);
    blue = map(pos.x/pos.y, 0, width/height, 0, 255);
    fill(red, green, blue, 100);
    ellipse(pos.x, pos.y, circSize, circSize);
    SinOsc sin = sinoscs.get(index);
    sin.play(300 + cModifier, .1);
    float sinAmp = map(circSize, 20, width, 0.05, 1);
    sin.amp(sinAmp);
  }

  void run() {
    update();
    display();
  }
}
