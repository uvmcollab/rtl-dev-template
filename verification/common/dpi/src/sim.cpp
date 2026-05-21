//==============================================================================
// [Filename]     sim.cpp
// [Project]      -
// [Author]       Ciro Bermudez - cirofabian.bermudez@gmail.com
// [Language]     C++
// [Created]      -
// [Modified]     -
// [Description]  Standalone simulation for the debouncer reference model
// [Notes]        -
// [Status]       stable
// [Revisions]    -
//==============================================================================

#include <stdint.h>
#include <stdio.h>

#include "debouncer.h"

int main() {
  const uint32_t clk_freq_hz = 100000000;
  const uint32_t stable_time_us = 1;

  Debouncer debouncer;
  debouncer.configure(clk_freq_hz, stable_time_us);

  bool rst = true;
  bool sw = false;

  char msg[64];

  printf("Begin of simulation\n");

  debouncer.step(rst, sw);
  debouncer.print_state("reset asserted");

  rst = false;
  for (int i = 0; i < 3; ++i) {
    debouncer.step(rst, sw);
    snprintf(msg, sizeof(msg), "idle %d", i);
    debouncer.print_state(msg);
  }

  sw = true;
  for (int i = 0; i < 105; ++i) {
    debouncer.step(rst, sw);
    snprintf(msg, sizeof(msg), "press %d", i);
    debouncer.print_state(msg);
  }

  sw = false;
  for (int i = 0; i < 105; ++i) {
    debouncer.step(rst, sw);
    snprintf(msg, sizeof(msg), "release %d", i);
    debouncer.print_state(msg);
  }

  printf("End of simulation\n");
  return 0;
}
