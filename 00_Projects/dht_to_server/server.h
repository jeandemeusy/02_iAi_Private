#pragma once

#include <ESPAsyncWebServer.h>
#include <ESPAsyncTCP.h>
#include "display.h"
#include "const.h"

AsyncWebServer server(80);

String processor(const String& var){
  char str_disp[15] = "";

  if(var == "TEMP")
    sprintf(str_disp,"%02d%c",temperature,(char)186);
  else if(var == "HUMI")
    sprintf(str_disp,"%02d%%",humidity);

  return str_disp;
}


String temperature_to_server() {
  return String(temperature);
}


String humidity_to_server() {
  return String(humidity);
}

void handle_temp(AsyncWebServerRequest *request) {
  request->send_P(200,"text/plain",temperature_to_server().c_str());
}

void handle_humi(AsyncWebServerRequest *request) {
  request->send_P(200,"text/plain",humidity_to_server().c_str());
}

void handle_root(AsyncWebServerRequest *request) {
  request->send(SPIFFS, "/index.html");
}

void server_setup() {
  display_str(0,7,"Web..",1000);

  server.on("/", HTTP_GET, handle_root);
  server.on("/temperature", HTTP_GET, handle_temp);
  server.on("/humidity", HTTP_GET, handle_humi);
  server.begin();

  display_str(0,7,"Web Y",1000);
}
