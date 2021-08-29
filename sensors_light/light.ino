#define GREEN   9
#define RED    10
#define BLUE   11
#define COLOUR RED

unsigned long time_sensor = millis();
unsigned long time_fade = millis();
unsigned long time_inc = millis();
int lightsensor = in[1];
int brightness = 0;
int period = 2500;
float t = 0.0;
int lightsensorvalue = 0;
int bufsize = 20;
int buf[20];
int bufcount = 0;
int avg = 0;

void setupLight() {
  pinMode(RED, OUTPUT);
  pinMode(GREEN, OUTPUT);
  pinMode(BLUE, OUTPUT);
  analogWrite(RED, 0);
  analogWrite(GREEN, 0);
  analogWrite(BLUE, 0);
}

void loopLight() {
  fadeblinking();
  //sensiblelight();
  analogWrite(COLOUR, brightness);
  Serial.println(brightness);
}

void fadeblinking() {
  //lightsensorvalue = analogRead(in[1]) * 2 + 1;
  t = 2 * PI * millis()/4000;
  brightness = 255 * abs(sin(t));
}

void sensiblelight() {
  brightness = smooth();
}

int smooth() {
  lightsensorvalue = analogRead(lightsensor);
  buf[bufcount] = lightsensorvalue;
  for(int i = 0; i < bufsize; i++) {
   avg += buf[i];
  }
  avg = avg / bufsize;
  bufcount++;
  bufcount = bufcount % bufsize;
  return avg;
}
