`ifndef VIF_IF_SV
`define VIF_IF_SV

interface vif_if(
    input logic clk_i
); 

  timeunit      1ns;
  timeprecision 1ps;
  
  localparam int Width = 8;

  logic rst_i;
  logic [Width-1:0] value_i;
  logic [Width-1:0] a_o;
  logic [Width-1:0] b_o;
  logic [Width-1:0] c_o;
  logic [Width-1:0] d_o;
  logic [Width-1:0] e_o;
  logic [Width-1:0] f_o;
  logic [Width-1:0] g_o;
  logic [Width-1:0] h_o;
  logic [2:0] sel_i;
  clocking cb @(posedge clk_i);
    default input #1ns output #1ns;
    output rst_i;
    output sel_i;
    output value_i;
  endclocking : cb

endinterface : vif_if

`endif // VIF_IF_SV
