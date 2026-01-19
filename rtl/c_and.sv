module c_and#(
    parameter int Width =8
)(
    input logic clk_i,
    input logic rst_i,
    input logic a_i,
    input logic b_i,
    output logic y_o

);

always_ff @(posedge clk_i or posedge rst_i) begin
if(rst_i) begin
    y_o <= 1'b0;
end else begin
    y_o <= a_i & b_i;
end
end

endmodule: c_and