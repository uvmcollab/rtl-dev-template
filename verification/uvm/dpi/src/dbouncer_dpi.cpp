#include <svdpi.h>

#include "debouncer_model.hpp"

namespace {
DebouncerModel g_model;
}

extern "C" void debouncer_dpi_reset() { g_model.reset(); }

extern "C" void debouncer_dpi_step(const svBit rst,
                                   const svBit sw,
                                   svBit* db_level_o,
                                   svBit* db_tick_o,
                                   unsigned int* cycle) {
  const DebouncerPrediction y = g_model.step(rst != 0, sw != 0);

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
