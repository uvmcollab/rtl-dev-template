`ifndef VIF_IF_SV
`define VIF_IF_SV

interface vif_if(
    input logic clk_i
); 

  timeunit      1ns;
  timeprecision 1ps;
  
  localparam int Width = 8;

  logic rst_i;
  logic [Width-1:0] a_i;
  logic [Width-1:0] b_i;
  logic [Width-1:0] c_i;
  logic [Width-1:0] d_i;
  logic [Width-1:0] y_o;
  logic [1:0]sel_i;

  clocking cb @(posedge clk_i);
    default input #1ns output #1ns;
    output rst_i;
    output sel_i;
    output a_i;
    output b_i;
    output c_i;
    output d_i;
  endclocking : cb

endinterface : vif_if

`endif // VIF_IF_SV
