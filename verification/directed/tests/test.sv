module test (
    vif_if vif
);

  // =================== MAIN SEQUENCE ==================== //

  initial begin
    $display("Begin Of Simulation.");

    reset();

    fork
      begin
        send_data();
      end
      begin
        monitor_output();
      end
    join_any

    // Drain time
    #(100ns);
    $display("End Of Simulation.");
    $finish;
  end


  // ======================= TASKS ======================== //

  task automatic reset();
    // Initial values
    vif.rst_i = 1'b1;
    vif.d_i  = 'd0;
    repeat (2) @(vif.cb);
    vif.cb.rst_i <= 1'b0;
  endtask : reset


  task automatic send_data();
    for (int i = 0; i < 10; i++) begin
      @(vif.cb);
      vif.cb.d_i <= i;
    end
  endtask : send_data


  task automatic monitor_output();
    forever begin
      @(vif.q_o);
      $display("[INFO]: %8t: %4h", $realtime, vif.q_o);
    end
  endtask : monitor_output

endmodule : test
