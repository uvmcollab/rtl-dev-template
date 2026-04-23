//==============================================================================
// [Filename]     sim.cpp
// [Project]      rtl-dev-template
// [Author]       Ciro Bermudez - cirofabian.bermudez@gmail.com
// [Language]     C++
// [Created]      Apr 2026
// [Modified]     -
// [Description]  Standalone simulation entry point for the debouncer model
// [Notes]        -
// [Status]       stable
// [Revisions]    -
//==============================================================================

#include <cstdlib>
#include <iomanip>
#include <iostream>

#include "debouncer.h"

namespace {

void run_vector(Debouncer& model, bool rst, bool sw, std::size_t cycle) {
  const DebouncerPrediction y = model.step(rst, sw);
  std::cout << "cycle=" << std::setw(4) << cycle << " rst=" << rst << " sw=" << sw
            << " db_level_o=" << y.db_level_o << " db_tick_o=" << y.db_tick_o
            << " ref_cycle=" << y.cycle << '\n';
}

}  // namespace

int main(int argc, char** argv) {
  Debouncer model;

  std::size_t total_cycles = 140;
  if (argc > 1) {
    total_cycles = static_cast<std::size_t>(std::strtoul(argv[1], nullptr, 10));
  }

  for (std::size_t i = 0; i < total_cycles; ++i) {
    bool rst = (i < 5);
    bool sw = false;

    if (i >= 20 && i < 125) {
      sw = true;
    } else if (i >= 125) {
      sw = false;
    }

    run_vector(model, rst, sw, i);
  }

  return 0;
}
