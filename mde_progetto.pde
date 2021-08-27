import processing.sound.*;

int attemptsForLevel = 4;
IntList attempts = new IntList();

String experiment = "ex1";
String participant = "p01";
String session = "s01";


int currAttempt = 0;

// parametri esperimento
int numBalls = 22;
float minDiameter = 23;
float maxDiameter = 47;

boolean isTargetKnown = true;
boolean sonification = true;
boolean bump = true;

// fisica
float spring = 0.15;
float gravity = 0.01;
float friction = -0.75;
float speed = 0.15;

// palline
int solution;
Ball[] balls = new Ball[numBalls];


// suono
int numTones = 12;
TriOsc[] triWaves; 
float[] triFreq; 
int keyNote = 24;
int[] tones = {0, 12, 6, 9, 19, 24, 28, 31, 36, 40, 48, 60};
int[] detunes = {0,  -1,  0, 1,  0,  -1,  1,  0,  0, 1, 1, 0};
float smoothing = 0.025;
LowPass[] filters;
PinkNoise noise;
TriOsc bumper;
Env env;

long startTime;

color[] viridis;

String[] results;

int widthDim = 1000;

int sqsz = 40;

float step = 256.0 / (numBalls + 1);



void setup() {
  size(1300, 1000); 

  for (int i = 0; i < numTones; i++) {
    tones[i] += keyNote; 
  }

  loadViridis();

  for (int i = 0; i < attemptsForLevel; i++) {
    attempts.append('n');
    attempts.append('s');
    attempts.append('b');
  }
  attempts.shuffle();
  println(attempts);

  results = new String[attempts.size()];

  restart();

  
}

void storeResults() {
  saveStrings(String.format("results/%s%s%s-%d\\%d\\%d-%d:%d", experiment, participant, session, 
                                            day(), month(), year(), hour(), minute()), results);
}

void restart() {

  solution = (int) random(numBalls);

  int level = attempts.get(currAttempt);

  if (level == 'n') {
    sonification = false;
    bump = false;
  } else if (level == 's') {
    sonification = true;
    bump = false;
  } else if (level == 'b') {
    sonification = true;
    bump = true;
  }

  for (int i = 0; i < numBalls; i++) {
    balls[i] = new Ball(random(widthDim), random(height), random(minDiameter, maxDiameter), i, balls);
  }
  startTime = System.currentTimeMillis();

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

void increaseAttempt() {
  currAttempt++;  
  if (currAttempt == attempts.size()) {
    storeResults();
    System.exit(0);
  }
}

void draw() {
  background(232, 232, 232);

  noStroke();
  fill(255, 255, 255);
  rect(widthDim, 0, width - widthDim, height, 0);

  if (isTargetKnown) {
    pushMatrix();
      fill(0);
      translate(widthDim + sqsz, height - 30);
      textSize(20);
      text("Clicca sul valore " + solution, 0, 0);       
    popMatrix();
  }

  for (Ball ball : balls) {
    //ball.collide();
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
    this.colorIndex = (int) (step * (id + 1) + random(-step * 1/2, step * 1/2));
    if (this.colorIndex < 0) this.colorIndex = 0;
    else if (this.colorIndex > 255) this.colorIndex = 255;
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

    // float delta = sqrt(mag(vx, vy)) * speed;


    vx += pow(vx * map(x, 0, widthDim, 0, 1), 1/3);
    vx -= pow(vx * map(widthDim - x, 0, widthDim, 0, 1), 1/3);

    vy += pow(vy * map(y, 0, height, 0, 1), 1/3);
    vy -= pow(vy * map(height - y, 0, height, 0, 1), 1/3);

    vx += random(-speed, speed);
    vy += random(-speed, speed);


    x += vx;
    y += vy;

    if ((int) random(300) == 0) {
        vx *= random(friction / 1.5) * 1.5;
        vy *= random(friction / 1.5) * 1.5;
        doBump();
    }
    

    float f = random(friction);
    
    if (x + diameter / 2 > widthDim) {
      x = widthDim - diameter / 2;
      vx *= f;
      if (f < friction * 0.75) doBump();
    }
    else if (x - diameter / 2 < 0) {
      x = diameter / 2;
      vx *= f;
      if (f < friction * 0.75) doBump();
    }
    if (y + diameter / 2 > height) {
      y = height - diameter / 2;
      vy *= f;
      if (f < friction * 0.75) doBump();
    } 
    else if (y - diameter / 2 < 0) {
      y = diameter / 2;
      vy *= f;
      if (f < friction * 0.75) doBump();
    }
  }
  
  //   void move() {
  //   float delta = sqrt(mag(vx, vy)) * speed;
  //   vx += random(-delta, delta);
  //   vy += random(-delta, delta);
  //   x += vx;
  //   y += vy;
  //   if (x + diameter / 2 > widthDim) {
  //     x = widthDim - diameter / 2;
  //     vx *= friction;
  //     doBump();
  //   }
  //   else if (x - diameter / 2 < 0) {
  //     x = diameter / 2;
  //     vx *= friction;
  //     doBump();
  //   }
  //   if (y + diameter / 2 > height) {
  //     y = height - diameter / 2;
  //     vy *= friction;
  //     doBump();
  //   } 
  //   else if (y - diameter / 2 < 0) {
  //     y = diameter / 2;
  //     vy *= friction;
  //     doBump();
  //   }
  // }

  void display() {
    fill(colorValue);
    stroke(255, 255, 255, 220);
    ellipse(x, y, diameter, diameter);
    noStroke();
    pushMatrix();  
      translate(widthDim + sqsz, id * sqsz + sqsz / 2);
      fill(232, 232, 232);
      rect(0, 0, sqsz, sqsz);
      fill(colorValue);
      rectMode(CENTER);
      rect(sqsz * 0.5, sqsz * 0.5, sqsz * 0.6, sqsz* 0.6);
      rectMode(CORNER);
      fill(160, 160, 160);
      textSize(16);
      if (id == solution) {
        fill(0);
      }
      text(id, sqsz * 1.2 , sqsz * 0.7); 
      noStroke();
    popMatrix();
  }

  void ring() {
    if (id == solution) {
      float offset = 0;
      float speedMag;
      for (int i = 0; i < numTones; i++) {
        speedMag = smoothing * mag(vx, vy) + (1 - smoothing) * oldSpeedMag;
        offset = map(speedMag, 0, 1, 0, 1);
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

  int dist = (int) Math.abs(pressedBall.colorIndex - balls[solution].colorIndex);
  float time = (System.currentTimeMillis() - startTime) / 1000.0;
  //println("distanza colore", dist);
  //println("tempo trascorso", time);

  // livello di sonification, 
  // tempo di completamento, 
  // colore taget, 
  // colore selezionato, 
  // distanza colore, 
  // dimensione target, 
  // dimensione cliccato
  results[currAttempt] = String.format("%c, %s, %d, %d, %d, %d, %d", 
      attempts.get(currAttempt), 
      str(time), 
      balls[solution].colorIndex, 
      pressedBall.colorIndex, 
      dist,
      (int) balls[solution].diameter,
      (int) pressedBall.diameter);
      
  println(results[currAttempt]);
  
  if (sonification) stopOscs();
  delay(1000);
  increaseAttempt();
  restart();
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


// dovremmo fare prima con e poi senza soniification? alternare?