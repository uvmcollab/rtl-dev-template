module D_mux #(
    parameter int Width = 8
)(
    input logic clk_i,
    input logic rst_i,
    input logic sel_i,
    input logic [Width-1:0] value_i,
    output logic [Width-1:0] a_o,
    output logic [Width-1:0] b_o
);

always_ff @(posedge clk_i or posedge rst_i) begin
if(rst_i) begin
    a_o <= '0;
    b_o <= '0; 
end 
    else if(!sel_i) begin
            a_o <= value_i;
    end 
        else begin
                b_o <= value_i;
        end
end

endmodule: D_mux