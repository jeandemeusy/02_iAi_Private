#pragma once

#include <U8g2lib.h>
#include "const.h"

#define DATA_PIN  D7
#define CS_PIN    D8
#define CLK_PIN   D5

U8G2_MAX7219_32X8_F_4W_SW_SPI u8g2(U8G2_R0, CLK_PIN, DATA_PIN, CS_PIN, U8X8_PIN_NONE, U8X8_PIN_NONE);

void handle_counter() {
  seq_idx += ++counter/max_counter[seq[seq_idx]];
  seq_idx %= (sizeof(seq) / sizeof(seq[0]));
  counter %= max_counter[seq[seq_idx]];
}

void display_str(int x, int y, char* str, int delay_t) {
  u8g2.clearBuffer();
  u8g2.drawStr(x, y, str);
  u8g2.sendBuffer();

#if VERBOSE
  Serial.println(str);
#endif

  delay(delay_t);
}

void u8g2_setup() {
  u8g2.begin();
  u8g2.setContrast(16*16-1);
  u8g2.setFont(u8g2_font_5x7_mr);

#if VERBOSE
  Serial.println("u8g2 setup done");
#endif
}
