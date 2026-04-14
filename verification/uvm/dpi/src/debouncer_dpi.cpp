//==============================================================================
// [Filename]     debouncer_dpi.cpp
// [Project]      rtl-dev-template
// [Author]       Ciro Bermudez - cirofabian.bermudez@gmail.com
// [Language]     C++
// [Created]      Apr 2026
// [Modified]     -
// [Description]  SystemVerilog DPI wrapper for the debouncer model
// [Notes]        -
// [Status]       stable
// [Revisions]    -
//==============================================================================

#include <svdpi.h>

#include "debouncer.h"

static Debouncer g_debouncer;

extern "C" void debouncer_dpi_reset() { g_debouncer.reset(); }

extern "C" void debouncer_dpi_step(const svBit rst,
                                   const svBit sw,
                                   svBit* db_level_o,
                                   svBit* db_tick_o,
                                   unsigned int* cycle) {
  const DebouncerPrediction y = g_debouncer.step(rst != 0, sw != 0);

  if (db_level_o != nullptr) {
    *db_level_o = y.db_level_o ? sv_1 : sv_0;
  }
  if (db_tick_o != nullptr) {
    *db_tick_o = y.db_tick_o ? sv_1 : sv_0;
  }
  if (cycle != nullptr) {
    *cycle = y.cycle;
  }
}
