#pragma once

#include <FS.h>
#include <Hash.h>
#define VERBOSE   0

typedef enum { TIME, DATE, TEMP_HUMI };
const int max_counter[] = { 25, 10, 10 };
const int seq[] = { TIME, TEMP_HUMI, TIME, DATE };

int temperature, humidity;
int months, days, hours, minutes;

char seq_idx = 0;
char counter = 0;

char str_to_print[10] = "";
char spacers[][2] = {":", " "};
char months_str[12][4] = {"Jan","Feb","Mar","Apr","May","Jun",
                          "Jul","Aug","Sep","Oct","Nov","Dec"};
