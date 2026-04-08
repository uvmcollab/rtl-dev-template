`ifndef TOP_SCOREBOARD_SV
`define TOP_SCOREBOARD_SV

class top_scoreboard extends uvm_scoreboard;

  `uvm_component_utils(top_scoreboard)

  `uvm_analysis_imp_decl(_observed)
  uvm_analysis_imp_observed #(debouncer_uvc_sequence_item, top_scoreboard) observed_imp_export;

  int m_num_passed;
  int m_num_failed;

  // Reference model variables
  int unsigned cycle_counter = 0;
  int unsigned sync_counter = 0;
  bit sw_state = 0;
  bit level_state = 0;
  bit tick_state = 0;
  
  int unsigned debug_counter = 0;

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

  if (debug_counter < 1100) begin
    `uvm_info(get_type_name(), {"\nDEBUG\n","\nRECEIVED:", received_trans.convert2string(), "\n", "\nREFMODEL:", reference_trans.convert2string(), "\n"}, UVM_MEDIUM)
    debug_counter++;
  end

  // Statistics
  if (is_equal) begin
    m_num_passed++;
  end else begin
    // `uvm_info(get_type_name(), {"\nMISMATCH\n","\nRECEIVED:", received_trans.convert2string(), "\n", "\nREFMODEL:", reference_trans.convert2string(), "\n"}, UVM_MEDIUM)
    m_num_failed++;
  end
  
endfunction : write_observed


function debouncer_uvc_sequence_item top_scoreboard::debouncer_ref(bit rst, bit sw);
  debouncer_uvc_sequence_item prediction;
  bit debounce_done;

  prediction = debouncer_uvc_sequence_item::type_id::create("prediction");

  // Reset logic
  if (rst) begin
    cycle_counter = 0;
    sw_state      = 1'b0;
    level_state   = 1'b0;
    tick_state    = 1'b0;
    sync_counter  = 0;
  end else begin

    // Phase 1: generate outputs form old state
    tick_state = 1'b0;
    debounce_done = (cycle_counter == 100);

    if (debounce_done) begin
      if (level_state == 1'b0 && sw_state == 1'b1) begin
        tick_state = 1'b1;
      end
      level_state = sw_state;
    end

    // Phase 2: update model state for next cycle
    if (sw != sw_state) begin
      sw_state = sw;
      sync_counter = 0;
      cycle_counter = 0;
    end else begin
      if (sync_counter < 2) begin
        sync_counter++;
      end else if (!debounce_done) begin
        cycle_counter++;
      end
    end
    

  end

  prediction.m_rst_i = rst;
  prediction.m_sw_i = sw;
  prediction.m_db_level_o = level_state;
  prediction.m_db_tick_o = tick_state;
  prediction.m_cycle = cycle_counter;
  
  return prediction;
endfunction : debouncer_ref


task top_scoreboard::run_phase(uvm_phase phase);
endtask : run_phase


function void top_scoreboard::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $sformatf("PASSED: %5d, FAILED: %5d", m_num_passed, m_num_failed), UVM_MEDIUM)
endfunction : report_phase


`endif // TOP_SCOREBOARD_SV