module sva #(
    parameter int ClkFreq    = 100_000_000,
    parameter int StableTime = 10
)(
    // Interface signals
    input logic clk_i,
    input logic rst_i,
    input logic sw_i,
    input logic db_level_o,
    input logic db_tick_o
);

  // $rose(db_level_o) |-> ( db_tick_o ##1 (!db_tick_o && db_level_o)[*10] );

  property p1;
    @(posedge clk_i) 
    $rose(db_level_o) |-> (db_tick_o ##1 !db_tick_o);
  endproperty

  property p2;
    @(posedge clk_i) 
    ((db_level_o && $past(db_level_o)) |-> !db_tick_o);
  endproperty

  assert_p1: assert property (p1)
    else $error("[SVA ERROR] %10t: db_tick_o didn't follow protocol", $realtime);

  assert_p2: assert property (p2)
    else $error("[SVA ERROR] %10t: db_tick_o didn't follow protocol", $realtime);

  cover_p1: cover property (p1);

endmodule
