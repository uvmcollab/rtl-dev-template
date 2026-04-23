module test_dpi (
    vif_if vif
);
  // =================== DPI FUNCTIONS ==================== //
  import "DPI-C" function real ref_model(real initial_value);

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
    fork
      begin
        // Aply DPI test
        $display("TEST DPI CONFIGURATION");
        dpi_test();
        $display("TEST DPI FINISHED"); 
      end
    join

    // Drain time
    #(100ns);
    $display("End Of Simulation.");
    $finish;
  end


  // ======================= TASKS ======================== //

  task automatic reset();
    vif.rst_i = 1'b1;
    vif.sw_i  = 1'b0;
    repeat (2) @(vif.cb);
    vif.cb.rst_i <= 1'b0;
    repeat (20) @(vif.cb);
  endtask : reset

  task automatic dpi_test();
  real dpi_result;
    dpi_result = ref_model(1.0);
    $display("DPI resultado = %f", dpi_result);
    if(dpi_result != 0.0) begin
      $display(" Simulation passed! ");
    end else begin
      $display(" Simulation failed! ");
    end
  endtask:dpi_test

endmodule : test_dpi




