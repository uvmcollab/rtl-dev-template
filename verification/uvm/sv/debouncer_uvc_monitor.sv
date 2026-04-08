`ifndef DEBOUNCER_UVC_MONITOR_SV
`define DEBOUNCER_UVC_MONITOR_SV

class debouncer_uvc_monitor extends uvm_monitor;

  `uvm_component_utils(debouncer_uvc_monitor)

  uvm_analysis_port #(debouncer_uvc_sequence_item) analysis_port;

  virtual debouncer_uvc_if    vif;
  debouncer_uvc_config        m_config;
  debouncer_uvc_sequence_item m_trans;
  
  int unsigned cycle = 0;

  extern function new(string name, uvm_component parent);

  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern task do_mon();

endclass : debouncer_uvc_monitor


function debouncer_uvc_monitor::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new


function void debouncer_uvc_monitor::build_phase(uvm_phase phase);
  analysis_port = new("analysis_port", this);
endfunction : build_phase


task debouncer_uvc_monitor::run_phase(uvm_phase phase);
  m_trans = debouncer_uvc_sequence_item::type_id::create("m_trans");
  do_mon();
endtask : run_phase


task debouncer_uvc_monitor::do_mon();
  forever begin

    @(vif.cb_mon);
    cycle++;

    m_trans.m_rst_i = vif.rst_i;
    m_trans.m_sw_i = vif.sw_i;
    m_trans.m_db_level_o = vif.db_level_o;
    m_trans.m_db_tick_o = vif.db_tick_o;

    m_trans.m_sample_time = $realtime;
    m_trans.m_cycle = cycle;
    
    analysis_port.write(m_trans);
  end
endtask : do_mon

`endif // DEBOUNCER_UVC_MONITOR_SV