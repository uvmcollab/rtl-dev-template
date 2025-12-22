module test (
    vif_if vif
);

    integer i;
    reg start = 0;

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

    @(posedge vif.clk) {vif.rst,vif.wr,vif.rd} = 3'b100;
    @(posedge vif.clk) {vif.rst,vif.wr,vif.rd} = 3'b101;
    @(posedge vif.clk) {vif.rst,vif.wr,vif.rd} = 3'b110;
    @(posedge vif.clk) {vif.rst,vif.wr,vif.rd} = 3'b111;
    @(posedge vif.clk) {vif.rst,vif.wr,vif.rd} = 3'b000; 
    
    write();
    @(posedge vif.clk) {vif.rst,vif.wr,vif.rd} = 3'b010;
    @(posedge vif.clk);
    
    read();

    // Drain time
    #(100ns);
    $display("End Of Simulation.");
    $finish;
  end

  // ======================= TASKS ======================== //

  task automatic reset();
    vif.rst = 1'b1;
    repeat (1) @(vif.cb);
    vif.cb.rst <= 1'b0;
    repeat (2) @(vif.cb);
  endtask : reset

  task write();
    for( i = 0; i < 15; i++)
      begin   
        vif.din = $urandom();
        vif.wr = 1'b1;
        vif.rd = 1'b0;
        @(posedge vif.clk);
      end
  endtask

  task read();
    for( i = 0; i < 15; i++)
      begin      
        vif.wr = 1'b0;
        vif.rd = 1'b1;
        @(posedge vif.clk);
      end
  endtask




endmodule : test
