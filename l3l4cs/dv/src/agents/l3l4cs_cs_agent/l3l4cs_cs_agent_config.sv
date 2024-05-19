// -------------------------------------------------------------------------
// File name		: l3l4cs_cs_agent_config.sv 
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
`ifndef CS_AGENT_CONFIG_SV
    `define CS_AGENT_CONFIG_SV
    
    class cs_agent_config extends ce_base_agent_config#(cs_agent_vif,l3l4cs_global,cs_agent_item,1);
        `uvm_object_utils(cs_agent_config)

        l3l4cs_global m_global;
        function new(string name = "");
            super.new(name);
        endfunction : new
    endclass : cs_agent_config
`endif // CS_AGENT_CONFIG_SV
