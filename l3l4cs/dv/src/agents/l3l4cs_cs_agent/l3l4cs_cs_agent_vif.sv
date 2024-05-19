// -------------------------------------------------------------------------
// File name		: l3l4cs_cs_agent_vif.sv 
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
`ifndef CS_AGENT_VIF_SV
    `define CS_AGENT_VIF_SV
    class cs_agent_vif extends ce_base_agent_vif#(virtual cs_agent_if);
        `uvm_object_utils( cs_agent_vif)

        extern function new(string name = "");
    endclass :   cs_agent_vif
    
    function  cs_agent_vif::new(string name = "");
        super.new(name);
    endfunction : new
`endif//  CS_AGENT_IF_SV
