//==========================================================
// debouncer_sva.sv
// Assertions for DUT module debouncer
//==========================================================

module debouncer_sva #(
    parameter int ClkFreq    = 100_000_000,
    parameter int StableTime = 10
)(
    input  logic clk_i,
    input  logic rst_i,
    input  logic sw_i,

    // Internal DUT signals
    input  logic ff1,
    input  logic ff2,
    input  logic ff3,
    input  logic ff4,
    input  logic clear_cnt,
    input  logic ena_cnt,
    input  logic db_level_o,
    input  logic db_tick_o,
    input  logic [$clog2(ClkFreq*StableTime/1_000_000)-1:0] cnt
);

  localparam int CounterMax   = ClkFreq * StableTime / 1_000_000;
  localparam int CounterWidth = $clog2(CounterMax);

  //==========================================================
  // Default SVA environment
  //==========================================================
  default clocking cb @(posedge clk_i); endclocking

  //==========================================================
  // 1. Synchronizer FF1/FF2 behavior
  //==========================================================
  property p_ff1_follows_sw;
    sw_i |=> ff1 == $past(sw_i);
  endproperty
  A1_1: assert property(p_ff1_follows_sw)
    else $error("ff1 does not follow sw_i");

  property p_ff2_follows_ff1;
    ff1 |=> ff2 == $past(ff1);
  endproperty
  A1_2: assert property(p_ff2_follows_ff1)
    else $error("ff2 does not follow ff1");

  A1_3: assert property (clear_cnt == (ff1 ^ ff2))
    else $error("clear_cnt != ff1 ^ ff2");

  //==========================================================
  // 2. Counter behavior
  //==========================================================
  property p_cnt_reset_or_clear;
    clear_cnt |=> cnt == '0;
  endproperty
  A2_1: assert property(p_cnt_reset_or_clear)
    else $error("Counter not cleared");

  property p_cnt_increment;
    (!clear_cnt && !ena_cnt) |=> cnt == $past(cnt) + 1;
  endproperty
  A2_2: assert property(p_cnt_increment)
    else $error("Counter not incrementing correctly");

  property p_cnt_hold_on_ena;
    ena_cnt |=> cnt == $past(cnt);
  endproperty
  A2_3: assert property(p_cnt_hold_on_ena)
    else $error("Counter must hold on ena_cnt");

  A2_4: assert property ( ena_cnt ==
                    (cnt == CounterMax[CounterWidth-1:0] - 1) )
    else $error("ena_cnt logic incorrect");

  //==========================================================
  // 3. Debounced level ff3/db_level_o
  //==========================================================
  property p_ff3_update_on_ena;
    ena_cnt |=> ff3 == $past(ff2);
  endproperty
  A3_1: assert property(p_ff3_update_on_ena)
    else $error("ff3 does not update correctly");

  A3_2: assert property (db_level_o == ff3)
    else $error("db_level_o must follow ff3");

  property p_lvl_changes_only_on_ena;
    $changed(db_level_o) |-> ena_cnt;
  endproperty
  A3_3: assert property(p_lvl_changes_only_on_ena)
    else $error("db_level_o changed outside ena_cnt");

  //==========================================================
  // 4. Tick ff4/db_tick_o
  //==========================================================
  A4_1: assert property (db_tick_o |-> ena_cnt)
    else $error("db_tick_o asserted without ena_cnt");

  property p_tick_logic;
    ena_cnt |-> db_tick_o == (~$past(ff3) & $past(ff2));
  endproperty
  A4_2: assert property(p_tick_logic)
    else $error("db_tick_o incorrect value");

  property p_tick_single_cycle;
    db_tick_o |=> !db_tick_o;
  endproperty
  A4_3: assert property(p_tick_single_cycle)
    else $error("db_tick_o must be one cycle");

  //==========================================================
  // Coverage
  //==========================================================
  C1: cover property ($rose(db_tick_o));
  C2: cover property (ena_cnt);
  C3: cover property (ff1 != ff2);

endmodule

