int in[5] =  {A1 , A2, A3, A4, A5};
const long referenceMv = 5000;

void setup() {
  // put your setup code here, to run once:
  Serial.begin(115200);
}

void loop() {
  // put your main code herddfe, to run repeatedly:
  // Serial.print("Sensor:");
  for(int i=0; i<5; i++)
    {
      int val = analogRead(in[i]);
      int mV = (val * referenceMv) / 1023;
      int cm = getDistance(mV);
      Serial.print(cm);
      if (i<4)Serial.print(",");
      else Serial.println();
      //Serial.print(cm);
      //Serial.print(",");
    }
    //Serial.write(255);
    //Serial.println();
  delay(100);
    
}

//interpolación de la distancia a intervalos de 250mV
const int TABLE_ENTRIES = 12;
const int INTERVAL  = 250;
static int distance[TABLE_ENTRIES] = {150,140,130,100,60,50,40,35,30,25,20,15};
int getDistance(int mV) {
   if (mV > INTERVAL * TABLE_ENTRIES - 1)      return distance[TABLE_ENTRIES - 1];
   else {
      int index = mV / INTERVAL;
      float frac = (mV % 250) / (float)INTERVAL;
      return distance[index] - ((distance[index] - distance[index + 1]) * frac);
   }
}
