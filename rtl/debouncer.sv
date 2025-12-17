///////////////////////////////////////////////////////////////////////////////////
// [Filename]       debouncer.sv
// [Project]        debouncer_ip
// [Author]         Ciro Bermudez
// [Language]       SystemVerilog 2017 [IEEE Std. 1800-2017]
// [Created]        2024.06.22
// [Description]    Debouncer circuit
// [Notes]          Tick output is useful to test FSMs
//                  Level output emulates a Schmitt trigger
//                  ClkFreq:    is the FPGA frequency
//                  StableTime: is the waiting time in ms
//                  Example:
//                    ClkFreq    = 100_000_000    ->   100 MHz
//                    StableTime =          10    ->    10 ms
//                  Then:
//                    CounterMax   = ClkFreq*StableTime/1000 = 1_000_000
//                    CounterWidth = $clog2(CounterMax) = 20
//                  To increase the precision it is possible to change
//                  from ms to us or even to ns but you must adjust the
//                  division factor accordingly.
// [Status]         Stable
///////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 100ps

module debouncer #(
    parameter int ClkFreq    = 100_000_000,
    parameter int StableTime = 10
) (
    input  logic clk_i,
    input  logic rst_i,
    input  logic sw_i,
    output logic db_level_o,
    output logic db_tick_o
);

  // Internal variables
  logic ff1, ff2, ff3, ff4;
  logic ena_cnt, clear_cnt;

  // Run the button through two flip-flops to avoid metastability issues
  always_ff @(posedge clk_i, posedge rst_i) begin
    if (rst_i) begin
      ff1 <= 'd0;
      ff2 <= 'd0;
    end else begin
      ff1 <= sw_i;
      ff2 <= ff1;
    end
  end

  assign clear_cnt = ff1 ^ ff2;

  localparam int CounterMax = ClkFreq * StableTime / 1_000_000;
  localparam int CounterWidth = $clog2(CounterMax);
  logic [CounterWidth-1:0] cnt;

  // Counter logic
  always_ff @(posedge clk_i, posedge rst_i) begin
    if (rst_i) begin
      cnt <= 'd0;
    end else begin
      if (clear_cnt) begin
        cnt <= 'd0;
      end else if (~ena_cnt) begin
        cnt <= cnt + 1'b1;
      end
    end
  end

  assign ena_cnt = (cnt == CounterMax[CounterWidth-1:0] - 1) ? 1'b1 : 1'b0;

  // Output debounce level
  always_ff @(posedge clk_i, posedge rst_i) begin
    if (rst_i) begin
      ff3 <= 'd0;
    end else if (ena_cnt) begin
      ff3 <= ff2;
    end
  end

  assign db_level_o = ff3;

`ifdef ERROR1_VERSION

  // Output single tick with edge detector (ERROR)
  always_ff @(posedge clk_i, posedge rst_i) begin
    if (rst_i) begin
      ff4 <= 'd0;
    end else if (ena_cnt) begin
      ff4 <= ~ff3 & ff2;
    end
    // else begin // This is the fix that makes it correct
    //   ff4 <= 1'b0;
    // end
  end

  assign db_tick_o = ff4;

`elsif ERROR2_VERSION

  // Output single tick (CORRECT/SEQUENTIAL OUTPUT)
  typedef enum {ST_IDLE, ST_ACTIVE} state_type_e;
  state_type_e state_reg, state_next;
  logic ff4_next;

  // FSMD State and Data Registers
  always_ff @(posedge clk_i, posedge rst_i) begin
    if (rst_i) begin
      state_reg <= 'd0;
      ff4       <= 'd0;
    end else begin
      state_reg <= state_next;
      ff4       <= ff4_next;
    end
  end
  
  // FSMD Next State Logic and Output Logic
  always_comb begin
    state_next = state_reg;
    ff4_next   = ff4;
    case (state_reg)
      ST_IDLE: begin
        if (ena_cnt & ff2) begin
          ff4_next = 1'b1;
          state_next = ST_ACTIVE;
        end
      end
      ST_ACTIVE: begin
        ff4_next = 1'b0;
        state_next = ST_IDLE;
      end
    endcase
  end
  assign db_tick_o = ff4;

`elsif SEQ1_VERSION

  // Best solution for sequential output
  always_ff @(posedge clk_i or posedge rst_i) begin
    if (rst_i) begin
      ff4 <= 1'b0;
    end else begin
      ff4 <= ena_cnt & ff2 & ~ff3; // old ff3, current stable sample ff2
    end
  end
  assign db_tick_o = ff4;

`elsif SEQ2_VERSION

  // Using the FSM is overkill but it works

  // Output single tick (CORRECT/SEQUENTIAL OUTPUT)
  typedef enum {ST_IDLE, ST_ACTIVE} state_type_e;
  state_type_e state_reg, state_next;
  logic ff4_next;

  // FSMD State and Data Registers
  always_ff @(posedge clk_i, posedge rst_i) begin
    if (rst_i) begin
      state_reg <= 'd0;
      ff4       <= 'd0;
    end else begin
      state_reg <= state_next;
      ff4       <= ff4_next;
    end
  end
  
  // FSMD Next State Logic and Output Logic
  always_comb begin
    state_next = state_reg;
    ff4_next   = ff4;
    case (state_reg)
      ST_IDLE: begin
        if (ena_cnt & ff2 & ~ff3) begin
          ff4_next = 1'b1;
          state_next = ST_ACTIVE;
        end
      end
      ST_ACTIVE: begin
        ff4_next = 1'b0;
        if (ena_cnt & ~ff2 & ff3) begin
          state_next = ST_IDLE;
        end
      end
    endcase
  end
  assign db_tick_o = ff4;

`else

  // Output single tick (CORRECT/COMBINATIONAL OUTPUT)
  always_ff @(posedge clk_i, posedge rst_i) begin
    if (rst_i) begin
      ff4 <= 'd0;
    end else begin
      ff4 <= ff3;
    end
  end
  assign db_tick_o = ~ff4 & ff3;

`endif

endmodule
