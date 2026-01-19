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
  mux4_16 #(
    .Width(16)
  )
  dut(
      .clk_i(vif.clk_i),
      .rst_i(vif.rst_i),
      .sel_i(vif.sel_i),
      .a_i(vif.a_i),
      .b_i(vif.b_i),
      .c_i(vif.c_i),
      .d_i(vif.d_i),
      .y_o(vif.y_o)
  );

  initial begin
    $timeformat(-9, 1, "ns", 10);
  end

endmodule : tb
