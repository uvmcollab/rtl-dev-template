module tb;

  timeunit      1ns;
  timeprecision 1ps;

  import config_pkg::*;

  // Clock signal
  logic clk_i = 0;
  int unsigned MainClkPeriod = 10;  // 100 MHz -> 10 ns period
  always #(MainClkPeriod / 2) clk_i = ~clk_i;

  // Interface
  vif_if vif (clk_i);

  // Test
  test top_test (vif);

  // Instantiation
  debouncer #(
      .ClkFreq(ClkFreq),
      .StableTime(StableTime)
  ) dut (
      .clk_i(vif.clk_i),
      .rst_i(vif.rst_i),
      .sw_i(vif.sw_i),
      .db_level_o(vif.db_level_o),
      .db_tick_o(vif.db_tick_o)
  );

  initial begin
    $timeformat(-9, 1, "ns", 10);
  end

endmodule : tb
