// -------------------------------------------------------------------------
// File name		: l3l4cs_cs_agent_seq_lib.sv 
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
`ifndef CS_AGENT_SEQ_LIB_SV
    `define CS_AGENT_SEQ_LIB_SV
    class cs_agent_data_seq extends ce_base_agent_data_seq#(cs_agent_config,cs_agent_item);
        `uvm_object_utils(cs_agent_data_seq)
        extern function new(string name = "");
        extern virtual task pre_body();
        extern virtual task body();
    endclass : cs_agent_data_seq
    function cs_agent_data_seq::new(string name = "");
        super.new(name);
    endfunction : new
    task cs_agent_data_seq::pre_body();
        super.pre_body();
        items_num=20;//temporary
    endtask: pre_body
    
    task cs_agent_data_seq::body();
        super.body();
    endtask :body 
`endif// CS_AGENT_SEQ_LIB_SV
