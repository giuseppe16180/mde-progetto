import processing.sound.*;

int numBalls = 28;
float spring = 0.15;
float gravity = 0.01;
float friction = -0.5;
Ball[] balls = new Ball[numBalls];
TriOsc[] sineWaves; // Array of sines
float[] sineFreq; // Array of frequencies
int[] tones = { 36, 48, 42, 45, 55, 60, 64, 67, 72, 76, 84, 96}; // Number of oscillators to use
int[] detunes = {0,  -1,  0, 1,  0,  -1,  1,  0,  0, 1, 1, 0};
int numTones = 12;
int solution = 0;
color solutionColor;
float speed = 0.1;
float hueRange = 18; //più alto più facile, valori tra 0 e 100
float satBrighOset = 60; // più alto più facile valori tra 0 e 100
float referenceHue;
float smoothing = 0.025; // più alto più facile, valori tra 0 e 1
LowPass[] filters;
PinkNoise noise;
long startTime;
boolean sonification = true;

boolean userViridis = true;

boolean doBump = true;
float attackTime = 0.002;
float sustainTime = 0.04;
float sustainLevel = 0.3;
float releaseTime = 0.2;
int duration = 200;
int bumpNote = 34;
TriOsc bump;
Env env;

void restart() {


  referenceHue = random(100);

  float hue = (referenceHue + random(-hueRange, hueRange)) % 100; 
  if (hue < 0) hue = 100 + hue;
    
  solutionColor = userViridis ? viridis[(int)random(72)] : color(hue, random(satBrighOset, 100), random(satBrighOset, 100));

  for (int i = 0; i < numBalls; i++) {
    balls[i] = new Ball(random(width), random(height), random(25, 55), i, balls);
  }

  startTime = System.currentTimeMillis();
}

void setup() {

  size(1000, 1000);  
  colorMode(HSB, 100);

  restart();

  if (sonification) {

    sineWaves = new TriOsc[numTones]; // Initialize the oscillators
    sineFreq = new float[numTones]; // Initialize array for Frequencies
    filters = new LowPass[numTones + 1];

    for (int i = 0; i < numTones; i++) {
      // Calculate the amplitude for each oscillator
      float sineVolume = (1.0 / numTones) / (i + 1);
      // Create the oscillators
      sineWaves[i] = new TriOsc(this);
      // Start Oscillators
      sineWaves[i].play();
      // Set the amplitudes for all oscillators
      sineWaves[i].amp(sineVolume);

      sineFreq[i] = toneDetune(midiToFreq(tones[i]), detunes[tones[i] % 12]);
      
      filters[i] = new LowPass(this);
      filters[i].process(sineWaves[i], 0);
    }

    noise = new PinkNoise(this);
    noise.amp(0.5);
    noise.play();
    filters[numTones] = new LowPass(this);
    filters[numTones].process(noise, 0);
    
    bump = new TriOsc(this);
    env = new Env(this);
  }
}

void draw() {
  background(0);

  pushMatrix();  
    fill(solutionColor);
    translate(width / 2, height / 2);
    star(0, 0, 15, 30, 6); 
  popMatrix();

  for (Ball ball : balls) {
    ball.collide();
    ball.move();
    ball.display();  
    if (sonification) ball.ring();
  }
}

void star(float x, float y, float radius1, float radius2, int npoints) {
  float angle = TWO_PI / npoints;
  float halfAngle = angle/2.0;
  beginShape();
  for (float a = 0; a < TWO_PI; a += angle) {
    float sx = x + cos(a) * radius2;
    float sy = y + sin(a) * radius2;
    vertex(sx, sy);
    sx = x + cos(a+halfAngle) * radius1;
    sy = y + sin(a+halfAngle) * radius1;
    vertex(sx, sy);
  }
  endShape(CLOSE);
}

class Ball {
  
  public float x, y;
  public float diameter;
  float vx = 0;
  float vy = 0;
  int id;
  Ball[] others;
  color c;
  float speedMagg = 0;
  float oldSpeedMagg = 0;

  Ball(float xin, float yin, float din, int idin, Ball[] oin) {
    float hue = (referenceHue + random(-hueRange, hueRange)) % 100; 
    if (hue < 0) hue = 100 + hue;
    c = userViridis ? viridis[(int)random(72)] : color(hue, random(satBrighOset, 100), random(satBrighOset, 100));
    x = xin;
    y = yin;
    vx = 10 * random(-speed, speed);
    vy = 10 * random(-speed, speed);
    diameter = din;
    id = idin;
    others = oin;
    if (id == solution) {
      c = solutionColor;
    }
    didBump = new boolean[numBalls];
    
  } 
  
  void playBump() {
    if (doBump && (id == solution)) {
      println("bump", speedMagg);
      bump.stop();    
      bump.play(midiToFreq(34), 1);
      env.play(bump, attackTime, sustainTime, sustainLevel, releaseTime);
    }
  }
  
  boolean[] didBump;
  
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
        if (!didBump[i]) {
          playBump();
          didBump[i] = true;
        }
      } else {
        didBump[i] = false;
      }
    }   
  }
  
  void move() {

    vx += random(-speed, speed);
    vy += random(-speed, speed);
    x += vx;
    y += vy;
    if (x + diameter/2 > width) {
      x = width - diameter/2;
      vx *= friction;
      playBump();
    }
    else if (x - diameter/2 < 0) {
      x = diameter/2;
      vx *= friction;
      playBump();
    }
    if (y + diameter/2 > height) {
      y = height - diameter/2;
      vy *= friction;
      playBump();
    } 
    else if (y - diameter/2 < 0) {
      y = diameter/2;
      vy *= friction;
      playBump();
    }
  }
  
  void display() {
    fill(c);
    ellipse(x, y, diameter, diameter);
  }

  float yoset;

  void ring() {

    if (id == solution) {

      for (int i = 0; i < numTones; i++) {
        //freq =  sineFreq[i] * (i + 1 * detune);
        speedMagg = smoothing * mag(vx, vy) + (1 - smoothing) * oldSpeedMagg;
        yoset = map(speedMagg, 0, 8, 0, 1);

        oldSpeedMagg = speedMagg;

        float frequency = sineFreq[i] * (1 + yoset);
         
        sineWaves[i].freq(frequency);
        filters[i].freq(map(pow(yoset, 1/2), 0, 1, sineFreq[0], 2 * sineFreq[numTones - 1]));
      }
      filters[numTones].freq(map(yoset, 0, 1, sineFreq[0], 2*sineFreq[numTones - 1]));
    }
  }



}



void stopOscs() {
  for (int i = 0; i < numTones; i++) {
    filters[i].stop();
    sineWaves[i].stop();
  }
  filters[numTones].stop();
  noise.stop();
  filters = null;
  sineWaves = null;
  noise = null;
}

void mousePressed() {
  if (mag(balls[solution].x - mouseX, balls[solution].y - mouseY) < 40) {
    println("preso");
  } else {
    println("mancato");
  }
  if (sonification) stopOscs();
  println("tempo", (System.currentTimeMillis() - startTime) / 1000);

  // prendere il colore del coso più vicino e fare la distanza
  // red()
  // green()	
  // blue()

  delay(1000);
  setup();
}


float midiToFreq(int note) {
  return (pow(2, ((note-69)/12.0))) * 440;
}

float toneDetune(float tone, int detune) {
  if (detune == 0) {
    return tone;
  }
  else if (detune < 0) { 
    return pow(2, ((100 + detune) / 100.0)) * (tone / 2);
  }
  else { 
    return pow(2, (detune / 100.0)) * tone;
  }
}




color[] viridis = {
  #440154, #440558, #450a5c, #450e60, #451465, #461969,
  #461d6d, #462372, #472775, #472c7a, #46307c, #45337d,
  #433880, #423c81, #404184, #3f4686, #3d4a88, #3c4f8a,
  #3b518b, #39558b, #37598c, #365c8c, #34608c, #33638d,
  #31678d, #2f6b8d, #2d6e8e, #2c718e, #2b748e, #29788e,
  #287c8e, #277f8e, #25848d, #24878d, #238b8d, #218f8d,
  #21918d, #22958b, #23988a, #239b89, #249f87, #25a186,
  #25a584, #26a883, #27ab82, #29ae80, #2eb17d, #35b479,
  #3cb875, #42bb72, #49be6e, #4ec16b, #55c467, #5cc863,
  #61c960, #6bcc5a, #72ce55, #7cd04f, #85d349, #8dd544,
  #97d73e, #9ed93a, #a8db34, #b0dd31, #b8de30, #c3df2e,
  #cbe02d, #d6e22b, #e1e329, #eae428, #f5e626, #fde725
};
