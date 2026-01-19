
module c_not #(
  parameter int Width = 8
)(   
    input logic clk_i,
    input logic rst_i,
    input logic [Width-1:0] a_i,
    output logic [Width-1:0] y_o
);

always_ff @(posedge clk_i or posedge rst_i) begin
if(rst_i) begin
   y_o <= 1'b0; 
end else begin
    y_o <= ~a_i;
end
end
endmodule: c_not