`ifndef TOP_SCOREBOARD_SV
`define TOP_SCOREBOARD_SV

import "DPI-C" context function void debouncer_dpi_reset();
import "DPI-C" context function void debouncer_dpi_step(
  input bit rst,
  input bit sw,
  output bit db_level_o,
  output bit db_tick_o,
  output int unsigned cycle
);

class top_scoreboard extends uvm_scoreboard;

  `uvm_component_utils(top_scoreboard)

  `uvm_analysis_imp_decl(_observed)
  uvm_analysis_imp_observed #(debouncer_uvc_sequence_item, top_scoreboard) observed_imp_export;

  int m_num_passed;
  int m_num_failed;

  extern function new(string name, uvm_component parent);

  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern function void write_observed(debouncer_uvc_sequence_item t);
  extern function void report_phase(uvm_phase phase);

  // Reference model
  extern function debouncer_uvc_sequence_item debouncer_ref(bit rst, bit sw);

endclass : top_scoreboard


function top_scoreboard::new(string name, uvm_component parent);
  super.new(name, parent);
  m_num_passed = 0;
  m_num_failed = 0;
endfunction : new


function void top_scoreboard::build_phase(uvm_phase phase);
  observed_imp_export = new("observed_imp_export", this);
  debouncer_dpi_reset();
endfunction : build_phase


function void top_scoreboard::write_observed(debouncer_uvc_sequence_item t);
  debouncer_uvc_sequence_item received_trans;
  debouncer_uvc_sequence_item reference_trans;
  bit is_equal;

  // Capture transaction from monitor
  received_trans = debouncer_uvc_sequence_item::type_id::create("received_trans");
  received_trans.copy(t);
  
  // Reference model
  reference_trans = debouncer_ref(received_trans.m_rst_i, received_trans.m_sw_i);
  
  // Compare received vs reference model
  is_equal = received_trans.compare(reference_trans);

  // Statistics
  if (is_equal) begin
    m_num_passed++;
  end else begin
    `uvm_info(get_type_name(), {"\nMISMATCH\n","\nRECEIVED:", received_trans.convert2string(), "\n", "\nREFMODEL:", reference_trans.convert2string(), "\n"}, UVM_MEDIUM)
    m_num_failed++;
  end
  
  // Stop condition
  if (m_num_failed > 500) begin
    `uvm_fatal(get_name(), $sformatf("\nNumber of failures exceeded. FAILED: %4d", m_num_failed))
  end
  
endfunction : write_observed


// Spec model:
// 1. If sw remains unchanged for CounterMax cycles, counting cycles 0..CounterMax-1,
//    the value is accepted as debounced.
// 2. Outputs respond 2 cycles later.
// 3. db_tick_o pulses for one cycle only on a debounced 0->1 transition.
function debouncer_uvc_sequence_item top_scoreboard::debouncer_ref(bit rst, bit sw);
  debouncer_uvc_sequence_item prediction;
  bit db_level_o;
  bit db_tick_o;
  int unsigned cycle;

  prediction = debouncer_uvc_sequence_item::type_id::create("prediction");

  debouncer_dpi_step(rst, sw, db_level_o, db_tick_o, cycle);

  prediction.m_rst_i = rst;
  prediction.m_sw_i = sw;
  prediction.m_db_level_o = db_level_o;
  prediction.m_db_tick_o = db_tick_o;
  prediction.m_cycle = cycle;
  
  return prediction;

endfunction : debouncer_ref


task top_scoreboard::run_phase(uvm_phase phase);
endtask : run_phase


function void top_scoreboard::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $sformatf("PASSED: %5d, FAILED: %5d", m_num_passed, m_num_failed), UVM_MEDIUM)
endfunction : report_phase


`endif // TOP_SCOREBOARD_SV
