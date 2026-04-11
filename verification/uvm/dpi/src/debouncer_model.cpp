#include "debouncer_model.hpp"

DebouncerModel::DebouncerModel() { reset(); }

void DebouncerModel::reset() {
  cycle_counter_ = 0;
  sync_counter_ = 0;
  sw_state_ = false;
  level_state_ = false;
  tick_state_ = false;
  value_to_load_ = false;
}

DebouncerPrediction DebouncerModel::step(bool rst, bool sw) {
  if (rst) {
    reset();
  } else {
    tick_state_ = false;

    if (cycle_counter_ == 99U) {
      if (!level_state_ && value_to_load_) {
        tick_state_ = true;
      }
      level_state_ = value_to_load_;
    }

    if (sw != sw_state_) {
      sync_counter_ = 0;
    } else {
      ++sync_counter_;
    }

    if (sync_counter_ == 1U) {
      cycle_counter_ = 0;
      value_to_load_ = sw;
    } else {
      ++cycle_counter_;
    }

    sw_state_ = sw;
  }

  DebouncerPrediction y;
  y.db_level_o = level_state_;
  y.db_tick_o = tick_state_;
  y.cycle = cycle_counter_;
  return y;
}
