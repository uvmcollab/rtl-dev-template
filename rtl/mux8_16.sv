module mux8_16 #(
    parameter int Width = 16
)(
    input logic clk_i,
    input logic rst_i,
    input logic [2:0] sel_i,
    input logic [Width-1:0] a_i,
    input logic [Width-1:0] b_i,
    input logic [Width-1:0] c_i,
    input logic [Width-1:0] d_i,
    input logic [Width-1:0] e_i,
    input logic [Width-1:0] f_i,
    input logic [Width-1:0] g_i,
    input logic [Width-1:0] h_i,
    output logic [Width-1:0] y_o
);

always_ff @(posedge clk_i or posedge rst_i) begin
if(rst_i) begin
    y_o <= 1'b0;
end
    else begin
        case (sel_i)
            3'b000: y_o <= a_i;
            3'b001: y_o <= b_i;
            3'b010: y_o <= c_i;
            3'b011: y_o <= d_i;
            3'b100: y_o <= e_i;
            3'b101: y_o <= f_i;
            3'b110: y_o <= g_i;
            3'b111: y_o <= h_i;
            default: y_o <= '0;
        endcase
    end
end

endmodule: mux8_16