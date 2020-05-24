#pragma once

#include <WiFiUdp.h>
#include <NTPClient.h>
#include "display.h"
#include "const.h"

#define ESSID     "UPC2533113"
#define PASSWORD  "3u6udbtbtvjU"

WiFiUDP ntp_udp;
NTPClient timeClient(ntp_udp, "pool.ntp.org", 3600);

//===============================================================
// WiFi routines
//===============================================================
void wifi_setup() {
  display_str(0,7,"Wifi..",1000);

  WiFi.begin(ESSID, PASSWORD);
  while (WiFi.status() != WL_CONNECTED) {
    delay(50);
  }

  display_str(0,7,"Wifi Y",1000);

#if VERBOSE
  Serial.println(WiFi.localIP());
#endif
}

//===============================================================
// Time routines
//===============================================================
void update_time() {
    timeClient.update();
}

void get_time(int* hours, int* minutes, int* seconds) {
  timeClient.getTime(hours, minutes, seconds);
}

void get_day(int* months, int* days) {
  *months = timeClient.getMonth();
  *days = timeClient.getDayNum();
}

void time_setup() {
  timeClient.begin();
  delay(1000);

  timeClient.update();
  get_day(&months, &days);
}
