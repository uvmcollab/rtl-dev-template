`ifndef DEBOUNCER_UVC_SEQUENCE_ITEM_SV
`define DEBOUNCER_UVC_SEQUENCE_ITEM_SV

class debouncer_uvc_sequence_item extends uvm_sequence_item;

  `uvm_object_utils(debouncer_uvc_sequence_item)

  // Transaction variables
  rand int unsigned    m_delay_ps;
  rand int unsigned    m_pulse_width_ps;

  rand int unsigned    m_cycles_asserted;
  rand int unsigned    m_cycles_deasserted;

  rand bit             m_value;
  
  // Monitoring values
  bit                  m_db_level;
  bit                  m_db_tick;

  extern function new(string name = "");

  extern function void do_copy(uvm_object rhs);
  extern function bit do_compare(uvm_object rhs, uvm_comparer comparer);
  extern function void do_print(uvm_printer printer);
  extern function string convert2string();

endclass : debouncer_uvc_sequence_item


function debouncer_uvc_sequence_item::new(string name = "");
  super.new(name);
endfunction : new


function void debouncer_uvc_sequence_item::do_copy(uvm_object rhs);
  debouncer_uvc_sequence_item rhs_;
  if (!$cast(rhs_, rhs)) `uvm_fatal(get_type_name(), "Cast of rhs object failed")
  super.do_copy(rhs);
  m_delay_ps           = rhs_.m_delay_ps;
  m_pulse_width_ps     = rhs_.m_pulse_width_ps;
  m_value              = rhs_.m_value;
  m_db_level           = rhs_.m_db_level;
  m_db_tick            = rhs_.m_db_tick;
endfunction : do_copy


function bit debouncer_uvc_sequence_item::do_compare(uvm_object rhs, uvm_comparer comparer);
  bit result;
  debouncer_uvc_sequence_item rhs_;
  if (!$cast(rhs_, rhs)) `uvm_fatal(get_type_name(), "Cast of rhs object failed")
  result = super.do_compare(rhs, comparer);
  result &= (m_delay_ps           == rhs_.m_delay_ps);
  result &= (m_pulse_width_ps     == rhs_.m_pulse_width_ps);
  result &= (m_value              == rhs_.m_value);
  result &= (m_db_level           == rhs_.m_db_level);
  result &= (m_db_tick            == rhs_.m_db_tick);
  return result;
endfunction : do_compare


function void debouncer_uvc_sequence_item::do_print(uvm_printer printer);
  if (printer.knobs.sprint == 0) `uvm_info(get_type_name(), convert2string(), UVM_MEDIUM)
  else printer.m_string = convert2string();
endfunction : do_print


function string debouncer_uvc_sequence_item::convert2string();
  string s;
  s = super.convert2string();
  $sformat(s, {s, "\n", "TRANSACTION INFORMATION (DEBOUNCER_UVC):"});
  $sformat(s, {s, "\n", "m_delay_ps = %d"}, m_delay_ps);
  $sformat(s, {s, "\n", "m_pulse_width_ps = %d"}, m_pulse_width_ps);
  $sformat(s, {s, "\n", "m_value = %d"}, m_value);
  $sformat(s, {s, "\n", "m_db_level = %d"}, m_db_level);
  $sformat(s, {s, "\n", "m_db_tick = %d"}, m_db_tick);
  return s;
endfunction : convert2string

`endif // DEBOUNCER_UVC_SEQUENCE_ITEM_SV