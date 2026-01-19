module mux4_16 #(
    parameter int Width = 16
)(
    input logic clk_i,
    input logic rst_i,
    input logic [1:0] sel_i,
    input logic [Width-1:0] a_i,
    input logic [Width-1:0] b_i,
    input logic [Width-1:0] c_i,
    input logic [Width-1:0] d_i,
    output logic [Width-1:0] y_o
);


always_ff @(posedge clk_i or posedge rst_i) begin
if(rst_i) begin
    y_o <= 1'b0;
end
    else begin
        case(sel_i)
            2'b00: y_o <= a_i;
            2'b01: y_o <= b_i;
            2'b10: y_o <= c_i;
            2'b11: y_o <= d_i;
            default: y_o <= '0;
        endcase
    end
end
endmodule:mux4_16