//==============================================================================
// [Filename]     debouncer.h
// [Project]      rtl-dev-template
// [Author]       Ciro Bermudez - cirofabian.bermudez@gmail.com
// [Language]     C++
// [Created]      Apr 2026
// [Modified]     -
// [Description]  Debouncer reference model used by simulation and DPI wrapper
// [Notes]        -
// [Status]       stable
// [Revisions]    -
//==============================================================================

#ifndef DEBOUNCER_H
#define DEBOUNCER_H

#include <cstdint>

struct DebouncerPrediction {
  bool db_level_o;
  bool db_tick_o;
  std::uint32_t cycle;
};

class Debouncer {
 public:
  Debouncer();

  void reset();
  DebouncerPrediction step(bool rst, bool sw);

 private:
  std::uint32_t cycle_counter_;
  std::uint32_t sync_counter_;
  bool sw_state_;
  bool level_state_;
  bool tick_state_;
  bool value_to_load_;
};

#endif  // DEBOUNCER_H
