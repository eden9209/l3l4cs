// -------------------------------------------------------------------------
// File name		: l3l4cs_cs_agent_coverage.sv 
// Title				: 
// Project      	: 
// Developers   	: eden 
// Created      	: Fri July 13, 2023  08:24AM 
// Last modified  : 
// Description  	: 
// Notes        	: 
// Version			: 0.1
// ---------------------------------------------------------------------------
// Copyright 2023 (c) GuardKnox Ltd
// Confidential Proprietary 
// ---------------------------------------------------------------------------
`ifndef CS_AGENT_COVERAGE_SV
    `define CS_AGENT_COVERAGE_SV
    class cs_agent_coverage#(type ITM=cs_agent_item) extends ce_base_agent_coverage#(ITM);
        `uvm_component_param_utils(cs_agent_coverage)
        
        ITM trn;
     
       covergroup cvg_cs_outputs;

          option.per_instance=1;

            cvp_l3_cs: coverpoint (trn.l3_checksum_o) {
            //    bins non_ip = {2'b00};
                bins good_cs_l3 = {2'b01};
                bins bad_cs_l3 = {2'b10};
            }
   
            cvp_l4_cs: coverpoint (trn.l4_checksum_o) {
              //  bins non_tcp_udp = {2'b00};
                bins good_cs_l4 = {2'b01};
                bins bad_cs_l4 = {2'b10};
            }


            cvp_no_ip: coverpoint (trn.l3_checksum_o) {
                bins non_ip = {2'b00};
            }

            cvp_no_tcp_udp: coverpoint (trn.l4_checksum_o) {
                bins non_tcp_udp = {2'b00};
            }

            cvp_len_er_o: coverpoint (trn.length_error_o) {
                bins yes_len_err = {1'b1};
                bins no_len_err = {1'b0};
            }

  
          cvp_l3_x_l4_cs: cross cvp_l3_cs, cvp_l4_cs {

             bins G_cs_l3_G_cs_l4= binsof(cvp_l3_cs.good_cs_l3) intersect {1} && binsof(cvp_l4_cs.good_cs_l4) intersect {1};
             bins B_cs_l3_B_cs_l4 = binsof(cvp_l3_cs.bad_cs_l3) intersect {2} && binsof(cvp_l4_cs.bad_cs_l4) intersect {2};
             
            }

      endgroup // cvg_cs_outputs

        function new(string name, uvm_component parent);
            super.new(name, parent);
            cvg_cs_outputs = new();
            cvg_cs_outputs.set_inst_name($sformatf("%s_%s",get_full_name(),"cvg_cs_outputs"));

        endfunction : new
        function void write(input ITM t);
            super.write(t);
            trn=t;
            cvg_cs_outputs.sample();
        endfunction : write
    endclass : cs_agent_coverage 
   
`endif // CS_AGENT_COVERAGE_SV
