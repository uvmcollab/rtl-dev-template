//==============================================================================
// [Filename]     debouncer_dpi.cpp
// [Project]      -
// [Author]       Ciro Bermudez - cirofabian.bermudez@gmail.com
// [Language]     C++
// [Created]      -
// [Modified]     -
// [Description]  DPI wrapper for the debouncer reference model
// [Notes]        -
// [Status]       stable
// [Revisions]    -
//==============================================================================

#include "svdpi.h"
#include "debouncer.h"

static Debouncer g_debouncer;

extern "C" void debouncer_init(unsigned int clk_freq_hz, unsigned int stable_time_us) {
  g_debouncer.configure(clk_freq_hz, stable_time_us);
}


extern "C" void debouncer_reset() {
  g_debouncer.reset();
}


extern "C" void debouncer_step(
    svBit rst,
    svBit sw,
    svBit* tick_state,
    svBit* level_state,
    unsigned int* cycle_counter
) {
  g_debouncer.step(static_cast<bool>(rst), static_cast<bool>(sw));

  *tick_state = static_cast<svBit>(g_debouncer.db_tick());
  *level_state = static_cast<svBit>(g_debouncer.db_level());
  *cycle_counter = g_debouncer.cycle_counter();
}
