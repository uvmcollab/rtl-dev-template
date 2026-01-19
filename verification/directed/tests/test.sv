module test (
    vif_if vif
);

  // =================== MAIN SEQUENCE ==================== //

  initial begin
    $display("Begin Of Simulation.");

    reset();

    fork
      begin
        send_data_port_a();
      end
      begin
        send_data_port_b();
      end
      begin
        send_data_port_c();
      end
      begin
        send_data_port_d();
      end
      begin
        send_data_port_e();
      end
      begin
        send_data_port_f();
      end
      begin
        send_data_port_g();
      end
      begin
        send_data_port_h();
      end
      //begin
      //  send_data_value();
      //end
      begin
        send_data_port_select();
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
    vif.a_i  = 'd0;
    vif.b_i = 'd0;
    vif.c_i = 'd0;
    vif.d_i = 'd0;
    vif.sel_i = 'd0;
    //vif.value_i = 'd0;
    //vif.y_o  = 'd0;
    repeat (2) @(vif.cb);
    vif.cb.rst_i <= 1'b0;
  endtask : reset


  task automatic send_data_port_a();
    for (int i = 0; i < 10; i++) begin
      @(vif.cb);
      vif.cb.a_i <= i;
    end
  endtask : send_data_port_a

  task automatic send_data_port_b();
  for (int i= 10; i >=0; i--)begin
    @(vif.cb);
    vif.cb.b_i <= i;
  end
  endtask: send_data_port_b

    task automatic send_data_port_c();
  for (int i= 10; i >=0; i--)begin
    @(vif.cb);
    vif.cb.c_i <= i;
  end
  endtask: send_data_port_c

  task automatic send_data_port_d();
  for (int i= 10; i >=0; i--)begin
    @(vif.cb);
    vif.cb.d_i <= i;
  end
  endtask: send_data_port_d

  task automatic send_data_port_e();
    for (int i = 0; i < 10; i++) begin
      @(vif.cb);
      vif.cb.e_i <= i;
    end
  endtask : send_data_port_e

  task automatic send_data_port_f();
  for (int i= 10; i >=0; i--)begin
    @(vif.cb);
    vif.cb.f_i <= i;
  end
  endtask: send_data_port_f

    task automatic send_data_port_g();
  for (int i= 10; i >=0; i--)begin
    @(vif.cb);
    vif.cb.g_i <= i;
  end
    endtask: send_data_port_g

  task automatic send_data_port_h();
  for (int i= 10; i >=0; i--)begin
    @(vif.cb);
    vif.cb.h_i <= i;
  end
  endtask: send_data_port_h

  //task automatic send_data_value();
  //
  //  for (int i =0 ; i <10 ; i++ ) begin
  //  @(vif.cb);
  //  vif.cb.value_i <= i;
  //end
  //endtask: send_data_value

  task automatic send_data_port_select();
  forever begin
    @(vif.cb);
    vif.cb.sel_i <= $urandom_range(0,8);
  end

  endtask: send_data_port_select

  task automatic monitor_output();
    forever begin
      @(vif.y_o);
      $display("[INFO: Demux]: %8t: Port A = %8b Port B = %8b Port C = %8b Port D = %8b  Port E = %8b Port F = %8b Port G = %8b Port H = %8b Selector = %d Salida = %8b ",    $realtime,vif.a_i, vif.b_i, vif.c_i, vif.d_i, vif.e_i, vif.f_i, vif.g_i, vif.h_i,  vif.sel_i, vif.y_o);
    end
  endtask : monitor_output

endmodule : test
