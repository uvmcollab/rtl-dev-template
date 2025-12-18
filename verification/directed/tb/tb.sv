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
  fifo 
   dut (
      .clk(vif.clk),
      .rst(vif.rst),
      .wr(vif.wr),
      .rd(vif.rd),
      .din(vif.din),
      .dout(vif.dout),
      .empty(vif.empty),
      .full(vif.full)
  );

  initial begin
    $timeformat(-9, 1, "ns", 10);
  end

endmodule : tb
