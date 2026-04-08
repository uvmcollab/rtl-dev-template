`ifndef DEBOUNCER_UVC_MONITOR_SV
`define DEBOUNCER_UVC_MONITOR_SV

class debouncer_uvc_monitor extends uvm_monitor;

  `uvm_component_utils(debouncer_uvc_monitor)

  uvm_analysis_port #(debouncer_uvc_sequence_item) analysis_port;

  virtual debouncer_uvc_if    vif;
  debouncer_uvc_config        m_config;
  debouncer_uvc_sequence_item m_trans;

  
  bit  db_level_state = 0;

  event asserted_level;
  event deasserted_level;
  

  extern function new(string name, uvm_component parent);

  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);

  extern task measure_asserted_cycles();
  extern task monitor_asserted_level();

  extern task measure_deasserted_cycles();
  extern task monitor_deasserted_level();
  
  extern task monitor_asserted_tick();
  extern task monitor_sanity_tick();
  
  extern task monitor_outputs();

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


task debouncer_uvc_monitor::measure_asserted_cycles();
  realtime start_time;
  realtime end_time;
  realtime diff;
  int unsigned cycles = 0;

  forever begin
    // Rising edge detector
    @(posedge vif.sw_i);
    start_time = $realtime();
    cycles = 0;

    while (vif.sw_i == 1) begin
      @(vif.cb_mon);
      if (vif.sw_i == 1) begin
        cycles++;
      end

      if (cycles == 100) begin
        end_time = $realtime();
        diff = end_time - start_time;
        end_time = end_time + 20ns;

        if (db_level_state != 1) begin
          `uvm_info(get_type_name(), 
            $sformatf("Predicted: %t UP", end_time), 
            UVM_MEDIUM)
        end

        db_level_state = 1;
        break;
      end

    end

  end
endtask : measure_asserted_cycles


task debouncer_uvc_monitor::measure_deasserted_cycles();
  realtime start_time;
  realtime end_time;
  realtime diff;
  int unsigned cycles = 0;

  forever begin
    // Rising edge detector
    @(negedge vif.sw_i);
    start_time = $realtime();
    cycles = 0;

    while (vif.sw_i == 0) begin
      @(vif.cb_mon);
      if (vif.sw_i == 0) begin
        cycles++;
      end

      if (cycles == 100) begin
        end_time = $realtime();
        diff = end_time - start_time;
        end_time = end_time + 20ns;

        if (db_level_state != 0) begin
        `uvm_info(get_type_name(), 
          $sformatf("Predicted: %t DOWN", end_time), 
          UVM_MEDIUM)
        end

        db_level_state = 0;
        break;
      end

    end

  end
endtask : measure_deasserted_cycles


task debouncer_uvc_monitor::monitor_asserted_level();
  realtime capture_time;
  bit prev_db_level_o;

  prev_db_level_o = vif.db_level_o;

  forever begin
    @(vif.cb_mon);
    if (!prev_db_level_o && vif.db_level_o) begin
      -> asserted_level;
      capture_time = $realtime();
      `uvm_info(get_type_name(), 
        $sformatf("db_level_o asserted: %t", capture_time), 
        UVM_MEDIUM)
    end
    prev_db_level_o = vif.db_level_o;
  end
endtask : monitor_asserted_level


task debouncer_uvc_monitor::monitor_deasserted_level();
  realtime capture_time;
  bit prev_db_level_o;

  prev_db_level_o = vif.db_level_o;

  forever begin
    @(vif.cb_mon);
    if (prev_db_level_o && !vif.db_level_o) begin
      -> deasserted_level;
      capture_time = $realtime;
      `uvm_info(get_type_name(),
        $sformatf("db_level_o deasserted: %t", capture_time),
        UVM_MEDIUM)
    end
    prev_db_level_o = vif.db_level_o;
  end
endtask : monitor_deasserted_level


task debouncer_uvc_monitor::monitor_asserted_tick();
  realtime capture_time;
  forever begin
    @(posedge vif.db_tick_o);
    capture_time = $realtime();
    `uvm_info(get_type_name(), 
      $sformatf("db_tick_o asserted: %t", capture_time), 
      UVM_MEDIUM)
  end
endtask : monitor_asserted_tick



task debouncer_uvc_monitor::monitor_sanity_tick();
  forever begin
    @(asserted_level);
    if (vif.db_tick_o != 1) begin
    `uvm_error(get_type_name(), $sformatf("db_tick_o must be 1 at the same time as db_level_o"))
    end

    @(vif.cb_mon);
    if (vif.db_tick_o != 0) begin
      `uvm_error(get_type_name(), $sformatf("db_tick_o must be 1 for just one clock cycle"))
    end

    while (vif.db_level_o == 1) begin
      @(vif.cb_mon);
      if (vif.db_tick_o != 0) begin
        `uvm_error(get_type_name(), $sformatf("db_tick_o must be 1 for just one clock cycle"))
      end
    end
    
    
  end
endtask : monitor_sanity_tick


task debouncer_uvc_monitor::do_mon();
  fork
    measure_asserted_cycles();
    monitor_asserted_level();

    measure_deasserted_cycles();
    monitor_deasserted_level();
    
    monitor_asserted_tick();
    monitor_sanity_tick();
  join_none
  // analysis_port.write(m_trans);
endtask : do_mon

`endif // DEBOUNCER_UVC_MONITOR_SV