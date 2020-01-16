#include <Arduino.h>


int step = 1;
int fade = 0;
int pin  = 3;

void setup()
{
    pinMode(pin, OUTPUT);
}

void loop()
{

  analogWrite(pin, fade);
  if ((fade < 0) || (fade > 255))
      step =  -step;
  fade += step;

  delay(3);
}


