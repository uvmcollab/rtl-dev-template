module tb;

  timeunit      1ns;
  timeprecision 1ps;

  // Clock signal
  logic clk_i = 0;
  int unsigned MainClkPeriod = 10;
  always #(MainClkPeriod / 2) clk_i = ~clk_i;

  // Interface
  vif_if vif (clk_i);

  // Test
  test top_test (vif);

  // Instantiation
  buffer #(
      .Width(8)
  ) dut (
      .clk_i(vif.clk_i),
      .rst_i(vif.rst_i),
      .d_i(vif.d_i),
      .q_o(vif.q_o)
  );

  initial begin
    $timeformat(-9, 1, "ns", 10);
  end

endmodule : tb
