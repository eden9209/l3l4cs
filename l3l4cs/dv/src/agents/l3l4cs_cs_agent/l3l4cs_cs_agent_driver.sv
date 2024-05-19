
// -------------------------------------------------------------------------
// File name		: l3l4cs_cs_agent_driver.sv 
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
`ifndef CS_AGENT_DRIVER_SV
    `define CS_AGENT_DRIVER_SV
    class cs_agent_driver#(
        type ITM = cs_agent_item,
        type CFG = cs_agent_config 
    )  extends ce_base_driver #(ITM,CFG);

        `uvm_component_param_utils(cs_agent_driver #(ITM,CFG))

        function new(string name, uvm_component parent);
            super.new(name,parent);
        endfunction: new

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
        endfunction : build_phase

        virtual task do_drv();
            super.do_drv();
        endtask:do_drv
        virtual task start_cond();
        endtask:start_cond

    endclass : cs_agent_driver 
`endif // CS_AGENT_DRIVER_SV

