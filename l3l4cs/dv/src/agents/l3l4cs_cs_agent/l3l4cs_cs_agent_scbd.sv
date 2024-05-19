// -------------------------------------------------------------------------
// File name		: l3l4cs_cs_agent_scbd.sv 
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
`ifndef CS_AGENT_SCBD_SV
    `define CS_AGENT_SCBD_SV
    class cs_agent_scbd #(
        type CFG = cs_agent_config, 
        type ITM = cs_agent_item
    ) extends ce_base_scbd#(CFG,ITM);

        `uvm_component_param_utils(cs_agent_scbd#(CFG,ITM))
        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction: new
    endclass : cs_agent_scbd 
`endif // CS_AGENT_SCBD_SV
