#include <ESP8266WiFi.h>
#include "const.h"
#include "server.h"
#include "wifi.h"
#include "display.h"
#include "sensor.h"

//===============================================================
// setup routine
//===============================================================
void setup(){
#if VERBOSE
  Serial.begin(115200);
#endif

  u8g2_setup();

  SPIFFS.begin();
  
  wifi_setup();
  time_setup();
  server_setup();
  sensor_setup();
}

//===============================================================
// loop routine
//===============================================================
void loop() {
  int temp_h, temp_m, temp_s;

  // Time update
  update_time();
  get_time(&temp_h, &temp_m, &temp_s);

  if (!temp_h && hours)
    get_day(&months, &days);
  hours = temp_h;
  minutes = temp_m;

  // Sensor update
  get_sensor_data(&temperature, &humidity);
  
  // Switch
  switch(seq[seq_idx]) {
  case TIME:
    sprintf(str_to_print,"%02d%s%02d",hours,spacers[temp_s%2],minutes);
    break;
  case DATE:
    sprintf(str_to_print,"%02d %s",days,months_str[months]);
    break;
  case TEMP_HUMI:
    sprintf(str_to_print,"%02d|%02d",temperature,humidity);
    break;
  default:
    sprintf(str_to_print,"...");
    break;
  }

  handle_counter();
  
  display_str(1,7,str_to_print,1000);
}
