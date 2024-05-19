// -------------------------------------------------------------------------
// File name		: l3l4cs_cs_agent_if.sv 
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
`ifndef  CS_AGENT_IF_SV
    `define  CS_AGENT_IF_SV

    interface  cs_agent_if(input clk,input reset_n); 

    parameter DATA=`CS_AGENT_DATA_WD;
     parameter VALID=`CS_AGENT_VLD_WD;
 
    `include "gk_base_if_common.sv"
   // `include "gk_axi_vip_if_common.sv"

   // `include "axis_vip_if_common.sv"

         
    logic[VALID-1:0] act_valid;
    logic[ DATA-1:0] act_data;

    
    logic[VALID-1:0] exp_valid;
    logic[ DATA-1:0] exp_data;


    bit checksum_valid_o;   
    bit [1:0] l3_checksum_o;   
    bit [1:0] l4_checksum_o;   
    bit l2_error_o;   
    bit length_error_o;   



    task wait_for_clk();
        @(posedge clk && reset_n===1'b1);
    endtask

        
    endinterface :  cs_agent_if
`endif //  CS_AGENT_IF_SV
