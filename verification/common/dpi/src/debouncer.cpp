//==============================================================================
// [Filename]     debouncer.cpp
// [Project]      -
// [Author]       Ciro Bermudez - cirofabian.bermudez@gmail.com
// [Language]     C++
// [Created]      Dec 2025
// [Modified]     -
// [Description]  Cycle-accurate C++ reference model for debouncer.sv
// [Notes]        Mirrors ff1/ff2/cnt/ff3/ff4 RTL state updates
// [Status]       stable
// [Revisions]    -
//==============================================================================

#include "debouncer.h"

#include <stdlib.h>

namespace {

uint32_t compute_counter_max(uint32_t clk_freq_hz, uint32_t stable_time_us) {
  const uint64_t product = static_cast<uint64_t>(clk_freq_hz) * stable_time_us;
  const uint32_t counter_max = static_cast<uint32_t>(product / 1000000ULL);

  if (counter_max == 0) {
    fprintf(stderr, "[ERROR] CounterMax must be greater than zero\n");
    abort();
  }

  return counter_max;
}

}  // namespace


Debouncer::Debouncer() = default;


Debouncer::Debouncer(uint32_t counter_max) {
  configure_counter_max(counter_max);
}


void Debouncer::configure(uint32_t clk_freq_hz, uint32_t stable_time_us) {
  configure_counter_max(compute_counter_max(clk_freq_hz, stable_time_us));
}


void Debouncer::configure_counter_max(uint32_t counter_max) {
  if (counter_max == 0) {
    fprintf(stderr, "[ERROR] CounterMax must be greater than zero\n");
    abort();
  }

  counter_max_reg = counter_max;
  reset();
}


void Debouncer::reset() {
  ff1_reg = false;
  ff2_reg = false;
  ff3_reg = false;
  ff4_reg = false;
  cnt_reg = 0;
}


void Debouncer::step(bool rst, bool sw) {
  if (rst) {
    reset();
    return;
  }

  const bool old_ff1 = ff1_reg;
  const bool old_ff2 = ff2_reg;
  const bool old_ff3 = ff3_reg;
  const uint32_t old_cnt = cnt_reg;

  const bool clear_cnt = old_ff1 ^ old_ff2;
  const bool ena_cnt = (old_cnt == (counter_max_reg - 1));

  ff1_reg = sw;
  ff2_reg = old_ff1;

  if (clear_cnt) {
    cnt_reg = 0;
  } else if (!ena_cnt) {
    cnt_reg = old_cnt + 1;
  } else {
    cnt_reg = old_cnt;
  }

  if (ena_cnt) {
    ff3_reg = old_ff2;
  }

  ff4_reg = old_ff3;
}


void Debouncer::print_state(const char* msg) const {
  printf("\n================ %s ================\n", msg);
  printf("CounterMax:       %u\n", counter_max_reg);
  printf("Counter:          %u\n", cnt_reg);
  printf("ff1:              %u\n", static_cast<unsigned>(ff1_reg));
  printf("ff2:              %u\n", static_cast<unsigned>(ff2_reg));
  printf("ff3/db_level_o:   %u\n", static_cast<unsigned>(ff3_reg));
  printf("ff4:              %u\n", static_cast<unsigned>(ff4_reg));
  printf("db_tick_o:        %u\n", static_cast<unsigned>(db_tick()));
}
