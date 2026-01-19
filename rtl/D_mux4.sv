module D_mux4 #(
    parameter int Width = 16
)(
    input logic clk_i,
    input logic rst_i,
    input logic [1:0] sel_i,
    input logic [Width-1:0] value_i,
    output logic [Width-1:0] a_o,
    output logic [Width-1:0] b_o,
    output logic [Width-1:0] c_o,
    output logic [Width-1:0] d_o
);

always_ff @(posedge clk_i or posedge rst_i) begin
if(rst_i) begin
   a_o <= '0;
   b_o <= '0;
   c_o <= '0;
   d_o <= '0;
end 
    else begin
        case (sel_i)
            2'b00: a_o <= value_i;
            2'b01: b_o <= value_i;
            2'b10: c_o <= value_i;
            2'b11: d_o <= value_i;
            default: begin
                a_o <= '0;
                b_o <= '0;
                c_o <= '0;
                d_o <= '0;
            end

        endcase

    end
end


endmodule: D_mux4