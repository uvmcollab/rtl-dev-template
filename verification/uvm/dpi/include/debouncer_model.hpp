#ifndef DEBOUNCER_MODEL_HPP
#define DEBOUNCER_MODEL_HPP

#include <cstdint>

struct DebouncerPrediction {
  bool db_level_o;
  bool db_tick_o;
  std::uint32_t cycle;
};

class DebouncerModel {
 public:
  DebouncerModel();

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

#endif  // DEBOUNCER_MODEL_HPP
