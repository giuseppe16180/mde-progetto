import processing.sound.*;

int numBalls = 22;
float spring = 0.15;
float gravity = 0.01;
float friction = -0.01;
Ball[] balls = new Ball[numBalls];
SinOsc[] sineWaves; // Array of sines
float[] sineFreq; // Array of frequencies
int numSines = 8; // Number of oscillators to use
int solution = 0;
float radius = sqrt(height * height + width * width);
color solutionColor = color(random(255), random(255), random(255));


void setup() {
  size(1080, 720);  
  for (int i = 0; i < numBalls; i++) {
    balls[i] = new Ball(random(width), random(height), random(25, 35), i, balls);
  }
  

  sineWaves = new SinOsc[numSines]; // Initialize the oscillators
  sineFreq = new float[numSines]; // Initialize array for Frequencies

  for (int i = 0; i < numSines; i++) {
    // Calculate the amplitude for each oscillator
    float sineVolume = (1.0 / numSines) / (i + 1);
    // Create the oscillators
    sineWaves[i] = new SinOsc(this);
    // Start Oscillators
    sineWaves[i].play();
    // Set the amplitudes for all oscillators
    sineWaves[i].amp(sineVolume);
  }
}

void draw() {
  background(0);
  fill(solutionColor);
  rect(10, 10, 30, 30);
  for (Ball ball : balls) {
    ball.collide();
    ball.move();
    ball.display();  
    ball.ring();
  }
}

class Ball {
  
  float x, y;
  float diameter;
  float vx = 0;
  float vy = 0;
  int id;
  Ball[] others;
  color c = color(random(255), random(255), random(255));
 
  Ball(float xin, float yin, float din, int idin, Ball[] oin) {
    x = xin;
    y = yin;
    diameter = din;
    id = idin;
    others = oin;
    if (id == solution) {
      c = solutionColor;
    }
  } 
  
  void collide() {
    for (int i = id + 1; i < numBalls; i++) {
      float dx = others[i].x - x;
      float dy = others[i].y - y;
      float distance = sqrt(dx*dx + dy*dy);
      float minDist = others[i].diameter/2 + diameter/2;
      if (distance < minDist) { 
        float angle = atan2(dy, dx);
        float targetX = x + cos(angle) * minDist;
        float targetY = y + sin(angle) * minDist;
        float ax = (targetX - others[i].x) * spring;
        float ay = (targetY - others[i].y) * spring;
        vx -= ax;
        vy -= ay;
        others[i].vx += ax;
        others[i].vy += ay;
      }
    }   
  }
  
  void move() {

    // if (id == solution) {
    //   x = width / 2;
    //   y = height / 2;
    //   return;
    // } 

    vx += random(-0.5, 0.5);
    vy += random(-0.5, 0.5);
    x += vx;
    y += vy;
    if (x + diameter/2 > width) {
      x = width - diameter/2;
      vx *= friction; 
    }
    else if (x - diameter/2 < 0) {
      x = diameter/2;
      vx *= friction;
    }
    if (y + diameter/2 > height) {
      y = height - diameter/2;
      vy *= friction; 
    } 
    else if (y - diameter/2 < 0) {
      y = diameter/2;
      vy *= friction;
    }
  }
  
  void display() {
    fill(c);
    ellipse(x, y, diameter, diameter);
  }
  
float max = 0.0;

  void ringOld() {

    if (id == solution) {
      //Map mouseY from 0 to 1
/*      float temp = mag(x - mouseX, y - mouseY);

      if (temp > max) {
        max = temp;
        println(max);
      }
*/

      float yoffset = 1 - map(mag(x - mouseX, y - mouseY), 0, radius, 0, 0.25);
      println(yoffset);
      //Map mouseY logarithmically to 150 - 1150 to create a base frequency range
      float frequency = pow(1000, yoffset) + 150;
      //Use mouseX mapped from -0.5 to 0.5 as a detune argument
      //float detune = map(mag(vx, vy), 0, 12, -0.5, 0.5);

      for (int i = 0; i < numSines; i++) { 
        sineFreq[i] = frequency * (i + 0.5);
        // Set the frequencies for all oscillators
        sineWaves[i].freq(sineFreq[i]);
      }
    }
  }

  void ring() {

    if (id == solution) {

      //float yoffset = 1 - map(mag(x - mouseX, y - mouseY), 0, radius, 0, 0.25);
      float yoffset = map(mag(vx, vy), 0, 14, 0, 1);
      println(yoffset);
      //Map mouseY logarithmically to 150 - 1150 to create a base frequency range
      float frequency = pow(1000, yoffset) + 150;
      //Use mouseX mapped from -0.5 to 0.5 as a detune argument
      //float detune = map(mag(vx, vy), 0, 12, -0.5, 0.5);

      for (int i = 0; i < numSines; i++) { 
        sineFreq[i] = frequency * (i + 1.5);
        // Set the frequencies for all oscillators
        sineWaves[i].freq(sineFreq[i]);
      }
    }
  }
}
