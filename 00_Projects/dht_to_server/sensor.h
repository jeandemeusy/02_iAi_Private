#pragma once

#include <DHT.h>
#include "const.h"

DHT dht(2, DHT11);

void get_sensor_data(int* temp, int* humi) {

  
  *temp = (int)dht.readTemperature();
  *humi = (int)dht.readHumidity();

#if VERBOSE
    Serial.print("Temperature: ");
    Serial.println(*temp);
    Serial.print("Humidity: ");
    Serial.println(*humi);
#endif
}

void sensor_setup() {
  dht.begin();
  
#if VERBOSE
  Serial.println("Sensor ready");
#endif
}
