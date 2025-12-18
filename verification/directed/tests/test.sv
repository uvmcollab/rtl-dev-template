module test (
    vif_if vif
);

  // ================== GLOBAL VARIABLES ================== //

  import config_pkg::*;

  // =================== MAIN SEQUENCE ==================== //

  initial begin
    // Initial values
    $display("Begin Of Simulation.");
    get_config_args();

    // Apply reset
    reset();

    // Stimulus
  

    // Drain time
    #(100ns);
    $display("End Of Simulation.");
    $finish;
  end


  // ======================= TASKS ======================== //

  task automatic reset();
    vif.rst = 1'b1;
    repeat (2) @(vif.cb);
    vif.cb.rst <= 1'b0;
    repeat (20) @(vif.cb);
  endtask : reset




endmodule : test
