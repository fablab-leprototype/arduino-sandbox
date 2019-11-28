#include <Arduino.h>
#include "DHT.h"

extern "C" void __cxa_pure_virtual() { while (1); }



DHT sensor(0x5, DHT11);

void setup()
{
    Serial.begin(9600);
    sensor.begin();
}

void loop()
{
  float temp = sensor.readTemperature(false);
  float hum = sensor.readHumidity(false);

  Serial.println("Temp:");
  Serial.println(temp);
  Serial.println("Hum: ");
  Serial.println(hum);

  delay(2000);
}
