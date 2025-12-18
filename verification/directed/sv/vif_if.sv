`ifndef VIF_IF_SV
`define VIF_IF_SV

interface vif_if(
    input logic clk
); 

  timeunit      1ns;
  timeprecision 1ps;
  
  import config_pkg::*;
  
  logic rst;
  logic wr;
  logic rd;
  logic din;
  logic dout;
  logic empty;
  logic full;

  clocking cb @(posedge clk);
    default input #1ns output #1ns;
    output rst;
  endclocking

endinterface : vif_if

`endif // VIF_IF_SV
