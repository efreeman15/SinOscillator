import processing.sound.*;
import ddf.minim.*;
import ddf.minim.ugens.*;

// to do: implement removal so sound disappears whenever circle disappears
// amke it so circles can't swallow each other (?) 
// if clicked in triangle everything disappears
// triangle animates
// fix click glitch

PVector circle1, circle2;
float cModifier1, cModifier2;
float amp1, amp2;
int red1, green1, blue1, red2, green2, blue2;
ArrayList<Circle> circles;
ArrayList<SinOsc> sinoscs;
Sound s;
int counter;
boolean triOn = false;
boolean recordOn = false;
Minim minim;

// for recording
AudioInput in;
AudioRecorder recorder;
boolean recorded;

// for playing back
AudioOutput out;
FilePlayer player;

void setup() {
  background(255);
  size(800, 600);
  circles = new ArrayList<Circle>();
  sinoscs = new ArrayList<SinOsc>();
  counter = 0;
  s = new Sound(this);
  minim = new Minim(this);

  // get a stereo line-in: sample buffer length of 2048
  // default sample rate is 44100, default bit depth is 16
  in = minim.getLineIn(Minim.STEREO, 2048);

  // create an AudioRecorder that will record from in to the filename specified.
  // the file will be located in the sketch's main folder.
  recorder = minim.createRecorder(in, "myrecording.wav");

  // get an output we can playback the recording on
  out = minim.getLineOut( Minim.STEREO );
}

void draw() {
  background(230);
  for (Circle circ : circles) {
    circ.run();
  }

  stroke(255);
  fill(240);
  rect(0, 0, 100, 60, 5);
  trashTriangle();
  recordButton();
  playTriangle();
}

void mousePressed() {
  boolean addnew = true;
  // if click is not on the control panel
  if (mouseX < 100 && mouseY < 60) {
    addnew = false;
  } else {
    // if click is within a circle then we don't want to add it
    for (int i = 0; i < circles.size(); i++) {
      Circle circ = circles.get(i);
      if (dist(circ.pos.x, circ.pos.y, mouseX, mouseY) < circ.circSize) {
        addnew = false;
        circ.circSize += 5;
      }
    }
  }
  // if it's not...
  if (addnew == true) {
    Circle c = new Circle(new PVector (mouseX, mouseY), counter);
    c.createCircle();
    SinOsc sin = new SinOsc(this);
    sinoscs.add(sin);
    counter++;
  }
  // if click is in triangle 
  if (dist(30, height - 25, mouseX, mouseY) < 30) {
    for (SinOsc sin : sinoscs) {
      sin.stop();
    }
    circles = new ArrayList<Circle>();
    sinoscs = new ArrayList<SinOsc>();
    counter = 0;
  }

  // if click is in record button
  if (dist(30, 30, mouseX, mouseY) < 40) {
    recordOn = !recordOn;
    if (recorded == true) {
      recorded = false;
    }
    if (recorder.isRecording() ) {
      recorder.endRecord();
      recorded = true;
      println("Stopped recording");
      if (player != null) {
        player.unpatch(out);
        player.close();
      }
      player = new FilePlayer(recorder.save());
    } else {
      println("Recording");
      recorder.beginRecord();
    }
  }

  //if click is in play triangle
  if (recorded && dist(80, 30, mouseX, mouseY) < 20) {
    println("Playing");
    if (player == null) {
      player.unpatch(out);
      player.close();
    } else {
      player.patch(out);
      player.play();
    }
  }
}


void mouseDragged() {
  // click in circle
  for (int i = 0; i < circles.size(); i++) {
    Circle circ = circles.get(i);

    // if it's within a circle
    if (dist(circ.pos.x, circ.pos.y, mouseX, mouseY) < circ.circSize) {
      // if you try to drag it to the recording panel
      if (circ.pos.x < 100 && circ.pos.y < 60) {
        removeCircle(circ, i);
        // if you don't
      } else {
        circ.pos.x = mouseX;
        circ.pos.y = mouseY;

        if (dist(circ.pos.x, circ.pos.y, 30, height - 25) < circ.circSize) {
          triOn = true;
        }
      }
    }
  }
}



void mouseReleased() {
  for (int i = 0; i < circles.size(); i++) {
    Circle circ = circles.get(i);
    //if it's near the triangle
    if (dist(circ.pos.x, circ.pos.y, 30, height - 25) < circ.circSize) {
      removeCircle(circ, i);
    }
  }
}

void removeCircle(Circle c, int i) {
  circles.remove(i);
  counter--;
  SinOsc sinCircle = sinoscs.get(c.index);
  sinCircle.stop();
  triOn = false;
}

void trashTriangle() {
  stroke(50, 50, 50, 50);
  if (triOn == false) {
    fill(100, 100, 100, 50);
  } else {
    fill(50, 50, 50, 50);
  }
  triangle(10, height - 10, 50, height - 10, 30, height - 44);
}

void recordButton() {
  strokeWeight(2);
  if (dist(30, 30, mouseX, mouseY) < 40) {
    if (recordOn) {
      fill(100, 200, 0, 150);
      stroke(50, 150, 0, 150);
    } else {
      fill(40, 255, 0, 150);
      stroke(50, 150, 0, 150);
    }
  } else {
    if (recordOn) {
      fill(100, 200, 0, 150);
      stroke(50, 150, 0, 150);
    } else {
      stroke(150, 0, 0, 150);
      fill(200, 0, 0, 150);
    }
  }
  ellipse(30, 30, 40, 40);
}

void playTriangle() {
  stroke(50, 50, 50, 50);
  fill(240);
  triangle(70, 50, 70, 10, 90, 30);
}
