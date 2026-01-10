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
    stress();
    
    // Small delay
    #(100ns);

    // Test write
    write();

    // Small delay
    #(100ns);
    
    // Test write
    read();

    // Drain time
    #(100ns);
    $display("End Of Simulation.");
    $finish;
  end

  // ======================= TASKS ======================== //

  task automatic reset();
    vif.rst  = 1'b1;
    vif.wr   = 1'b0;
    vif.rd   = 1'b0;
    vif.din  = 'd0;
    repeat (1) @(vif.cb);
    vif.cb.rst <= 1'b0;
    repeat (2) @(vif.cb);
  endtask : reset


  task automatic stress();
    // First reset
    @(vif.cb);
    vif.cb.rst <= 1'b1;
    vif.cb.wr  <= 1'b0;
    vif.cb.rd  <= 1'b0;

    // Reset and Read
    @(vif.cb);
    vif.cb.rst <= 1'b1;
    vif.cb.wr  <= 1'b0;
    vif.cb.rd  <= 1'b1;

    // Reset and Write
    @(vif.cb);
    vif.cb.rst <= 1'b1;
    vif.cb.wr  <= 1'b1;
    vif.cb.rd  <= 1'b0;

    // Reset and Read and Write
    @(vif.cb);
    vif.cb.rst <= 1'b1;
    vif.cb.wr  <= 1'b1;
    vif.cb.rd  <= 1'b1;

    // Release
    @(vif.cb);
    vif.cb.rst <= 1'b0;
    vif.cb.wr  <= 1'b0;
    vif.cb.rd  <= 1'b0;

    // Separation
    @(vif.cb);
  endtask : stress


  task automatic drive(logic [2:0] stimuli);
    @(vif.cb);
    vif.cb.rst <= stimuli[2];
    vif.cb.wr  <= stimuli[1];
    vif.cb.rd  <= stimuli[0];
  endtask : drive


  task automatic write();
    for(int i = 0; i < 15; i++) begin   
      @(vif.cb);
      vif.cb.din <= $urandom();
      vif.cb.wr  <= 1'b1;
      vif.cb.rd  <= 1'b0;
    end
    // Separation
    @(vif.cb);
    vif.cb.wr  <= 1'b0;
  endtask

  task automatic read();
    for(int i = 0; i < 15; i++) begin      
      @(vif.cb);
      vif.cb.wr <= 1'b0;
      vif.cb.rd <= 1'b1;
    end
    // Separation
    @(vif.cb);
    vif.cb.rd  <= 1'b0;
  endtask

endmodule : test
