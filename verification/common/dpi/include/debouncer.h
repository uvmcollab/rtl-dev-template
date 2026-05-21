//==============================================================================
// [Filename]     debouncer.h
// [Project]      -
// [Author]       Ciro Bermudez - cirofabian.bermudez@gmail.com
// [Language]     C++
// [Created]      Dec 2025
// [Modified]     -
// [Description]  Cycle-accurate C++ reference model for debouncer.sv
// [Notes]        -
// [Status]       stable
// [Revisions]    -
//==============================================================================

#ifndef DEBOUNCER_H
#define DEBOUNCER_H

#include <stdint.h>
#include <stdio.h>

class Debouncer {
  public:
    Debouncer();
    explicit Debouncer(uint32_t counter_max);

    void configure(uint32_t clk_freq_hz, uint32_t stable_time_us);
    void configure_counter_max(uint32_t counter_max);
    void reset();
    void step(bool rst, bool sw);
    void print_state(const char* msg = "State") const;

    bool db_level() const { return ff3_reg; }
    bool db_tick() const { return static_cast<bool>((!ff4_reg) && ff3_reg); }
    uint32_t cycle_counter() const { return cnt_reg; }
    uint32_t counter_max() const { return counter_max_reg; }

  private:
    uint32_t counter_max_reg = 100;

    bool ff1_reg = false;
    bool ff2_reg = false;
    bool ff3_reg = false;
    bool ff4_reg = false;
    uint32_t cnt_reg = 0;
};

#endif  // DEBOUNCER_H
