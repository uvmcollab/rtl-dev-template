module D_mux8 #(
    parameter int Width = 5
)(
    input logic clk_i,
    input logic rst_i,
    input logic [2:0] sel_i,
    input logic [Width-1:0] value_i,
    output logic [Width-1:0] a_o,
    output logic [Width-1:0] b_o,
    output logic [Width-1:0] c_o,
    output logic [Width-1:0] d_o,
    output logic [Width-1:0] e_o,
    output logic [Width-1:0] f_o,
    output logic [Width-1:0] g_o,
    output logic [Width-1:0] h_o
);  
always_ff @(posedge clk_i or posedge rst_i) begin   
if(rst_i) begin
   a_o <= '0;
   b_o <= '0;
   c_o <= '0;
   d_o <= '0;
   e_o <= '0;
   f_o <= '0;
   g_o <= '0;
   h_o <= '0;
end 
    else begin
        case (sel_i)
            3'b000: a_o <= value_i;
            3'b001: b_o <= value_i;
            3'b010: c_o <= value_i;
            3'b011: d_o <= value_i;
            3'b100: e_o <= value_i;
            3'b101: f_o <= value_i;
            3'b110: g_o <= value_i;
            3'b111: h_o <= value_i;
            default: begin
                a_o <= '0;
                b_o <= '0;
                c_o <= '0;
                d_o <= '0;
                e_o <= '0;
                f_o <= '0;
                g_o <= '0;
                h_o <= '0;
            end

        endcase

    end
end
endmodule: D_mux8