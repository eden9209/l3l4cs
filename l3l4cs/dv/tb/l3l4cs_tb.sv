

  module l3l4cs_tb;

      timeunit      1ns;
      timeprecision 1ps;

      int reset_period =10;
      parameter time clk_125M=8ns;

      logic clock_125;
      logic reset_n;
      logic rst;


      `include "uvm_macros.svh"
      
      initial begin
      clock_125  = 0;
        reset_n  = 0;
        rst=1;
      end

      always #(clk_125M/2)
      clock_125 = ~clock_125;

      initial  begin
        repeat(reset_period) @ (posedge clock_125);
        reset_n = 1;
      end


      initial  begin
      repeat(reset_period) @ (posedge clock_125);
      rst = 0;
      end

      l3l4cs_th  l3l4cs_th(.clk(clock_125),.reset_n(reset_n)); 


      `include "l3l4cs_th_connect.sv"

      L3L4CS 
      DUT
      (.sys_clk_i(clock_125),
      .srst_i(rst),
      .arst_n_i(reset_n),
      .as(l3l4cs_th.axi_slave_dut.slave_ports),
      .am(l3l4cs_th.axi_master_dut.master_ports),
      .markers_i(l3l4cs_th.mrk_dut),
      .checksum_valid_o(l3l4cs_th.cs_agent_if.checksum_valid_o),
      .l3_checksum_o(l3l4cs_th.cs_agent_if.l3_checksum_o),
      .l4_checksum_o(l3l4cs_th.cs_agent_if.l4_checksum_o),
      .l2_error_o(l3l4cs_th.cs_agent_if.l2_error_o),
      .length_error_o(l3l4cs_th.cs_agent_if.length_error_o) 
      );

      initial begin
        run_test();
      end

  endmodule

