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
  D_mux8 #(
    .Width(5)
  )
  dut(
      .clk_i(vif.clk_i),
      .rst_i(vif.rst_i),
      .sel_i(vif.sel_i),
      .value_i(vif.value_i),
      .a_o(vif.a_o),
      .b_o(vif.b_o),
      .c_o(vif.c_o),
      .d_o(vif.d_o),
      .e_o(vif.e_o),
      .f_o(vif.f_o),
      .g_o(vif.g_o),
      .h_o(vif.h_o)
  );

  initial begin
    $timeformat(-9, 1, "ns", 10);
  end

endmodule : tb
