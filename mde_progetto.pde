import processing.sound.*;

int attemptsForLevel = 4;
int[] levels = {'n', 's', 'b'};

String experiment = "ex1";
String participant = "p01";
String session = "s01";


int currAttempt = 0;
int currLevel = 0;

// parametri esperimento
int numBalls = 32;
float minDiameter = 23;
float maxDiameter = 37;

boolean isTargetKnown = true;
boolean sonification = true;
boolean bump = true;

// fisica
float spring = 0.15;
float gravity = 0.01;
float friction = -0.5;
float speed = 0.1;

// palline
int solution = 0;
Ball[] balls = new Ball[numBalls];


// suono
int numTones = 12;
TriOsc[] triWaves; 
float[] triFreq; 
int[] tones = { 36, 48, 42, 45, 55, 60, 64, 67, 72, 76, 84, 96};
int[] detunes = {0,  -1,  0, 1,  0,  -1,  1,  0,  0, 1, 1, 0};
float smoothing = 0.025;
LowPass[] filters;
PinkNoise noise;
TriOsc bumper;
Env env;

long startTime;

color[] viridis;

String[] results = new String[attemptsForLevel * levels.length];


void setup() {
  
  size(1000, 1000);  

  loadViridis();

  restart();

  if (sonification) {

    triWaves = new TriOsc[numTones];
    triFreq = new float[numTones];
    filters = new LowPass[numTones + 1];

    for (int i = 0; i < numTones; i++) {
      float triVolume = (1.0 / numTones) / (i + 1);
      triWaves[i] = new TriOsc(this);
      triWaves[i].play();
      triWaves[i].amp(triVolume);
      triFreq[i] = toneDetune(midiToFreq(tones[i]), detunes[tones[i] % 12]);
      filters[i] = new LowPass(this);
      filters[i].process(triWaves[i], 0);
    }

    noise = new PinkNoise(this);
    noise.amp(0.5);
    noise.play();
    filters[numTones] = new LowPass(this);
    filters[numTones].process(noise, 0);
    
    bumper = new TriOsc(this);
    env = new Env(this);
  }
}

void storeResults() {
  saveStrings(String.format("results/%s%s%s-%d\\%d\\%d-%d:%d", experiment, participant, session, 
                                            day(), month(), year(), hour(), minute()), results);
}

void restart() {

  if (levels[currLevel] == 'n') {
    sonification = false;
    bump = false;
  } else if (levels[currLevel] == 's') {
    sonification = true;
    bump = false;
  } else if (levels[currLevel] == 'b') {
    sonification = true;
    bump = true;
  }

  for (int i = 0; i < numBalls; i++) {
    balls[i] = new Ball(random(width), random(height), random(minDiameter, maxDiameter), i, balls);
  }
  startTime = System.currentTimeMillis();
}

void increaseAttempt() {
  currAttempt++;

  if (currAttempt % attemptsForLevel == 0) {
    currLevel++;
  }
  
  if (currLevel == levels.length) {
    storeResults();
    System.exit(0);
  }
}

void draw() {
  background(#ffffff);

  if (isTargetKnown) {
    pushMatrix();  
      fill(balls[solution].colorValue);
      translate(width / 2, height / 2);
      star(0, 0, 15, 30, 10); 
    popMatrix();
  }

  for (Ball ball : balls) {
    ball.collide();
    ball.move();
    ball.display();  
    if (sonification) ball.ring();
  }
}

class Ball {
  
  public float x, y;
  public float diameter;
  float vx = 0;
  float vy = 0;
  int id;
  Ball[] others;
  color colorValue;
  int colorIndex;
  float oldSpeedMag = 0;
  boolean[] didBump;

  Ball(float x, float y, float diameter, int id, Ball[] others) {
    this.colorIndex = (int) random(viridis.length);
    this.colorValue = viridis[colorIndex];
    this.x = x;
    this.y = y;
    this.vx = 10 * random(-speed, speed);
    this.vy = 10 * random(-speed, speed);
    this.diameter = diameter;
    this.id = id;
    this.others = others;
    this.didBump = new boolean[numBalls];
  } 
  
  void doBump() {
    if (sonification && bump && (id == solution)) {
      bumper.stop();    
      bumper.play(midiToFreq(34), 1);
      env.play(bumper, 0.002, 0.04, 0.3, 0.2);
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
        if (!didBump[i]) {
          doBump();
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
    if (x + diameter / 2 > width) {
      x = width - diameter / 2;
      vx *= friction;
      doBump();
    }
    else if (x - diameter / 2 < 0) {
      x = diameter / 2;
      vx *= friction;
      doBump();
    }
    if (y + diameter / 2 > height) {
      y = height - diameter / 2;
      vy *= friction;
      doBump();
    } 
    else if (y - diameter / 2 < 0) {
      y = diameter / 2;
      vy *= friction;
      doBump();
    }
  }
  
  void display() {
    fill(colorValue);
    ellipse(x, y, diameter, diameter);
  }

  void ring() {
    if (id == solution) {
      float offset = 0;
      float speedMag;
      for (int i = 0; i < numTones; i++) {
        speedMag = smoothing * mag(vx, vy) + (1 - smoothing) * oldSpeedMag;
        offset = map(speedMag, 0, 8, 0, 1);
        oldSpeedMag = speedMag;
        triWaves[i].freq(triFreq[i] * (1 + offset));
        filters[i].freq(map(pow(offset, 1/2), 0, 1, triFreq[0], 2 * triFreq[numTones - 1]));
      }
      filters[numTones].freq(map(offset, 0, 1, triFreq[0], 2 * triFreq[numTones - 1]));
    }
  }
}




// EVENTI

void mousePressed() {

  Ball pressedBall = balls[solution];

  for (int i = 0; i < numBalls; i++) {
    if (mag(balls[i].x - mouseX, balls[i].y - mouseY) < mag(pressedBall.x - mouseX, pressedBall.y - mouseY)) {
      pressedBall = balls[i];
    }
  }

  float dist = Math.abs(pressedBall.colorIndex - balls[solution].colorIndex) / 255.0;
  float time = (System.currentTimeMillis() - startTime) / 1000.0;
  //println("distanza colore", dist);
  //println("tempo trascorso", time);

  results[currAttempt] = String.format("%c, %s, %s", levels[currLevel], str(dist), str(time));
  println(results[currAttempt]);
  if (sonification) stopOscs();
  delay(1000);
  increaseAttempt();
  setup();
}



void stopOscs() {
  for (int i = 0; i < numTones; i++) {
    filters[i].stop();
    triWaves[i].stop();
  }
  filters[numTones].stop();
  noise.stop();
  filters = null;
  triWaves = null;
  noise = null;
}

void loadViridis() {
  viridis = new color[256];
  String[] stringColors = loadStrings("viridis.txt");
  for (int i = 0; i < 256; i++) {
    viridis[i] = unhex(stringColors[i]) | 0xff000000;
  }
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

// dovremmo fare prima con e poi senza soniification? alternare?