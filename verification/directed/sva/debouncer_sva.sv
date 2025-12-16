module deboucer_sva #(
    parameter int ClkFreq    = 100_000_000,
    parameter int StableTime = 10
)(
    // Interface signals
    input logic clk_i,
    input logic rst_i,
    input logic sw_i,
    input logic db_level_o,
    input logic db_tick_o,
    
    // Internal signals
    input  logic ff1,
    input  logic ff2,
    input  logic ff3,
    input  logic ff4,
    input  logic clear_cnt,
    input  logic ena_cnt,
);



endmodule
