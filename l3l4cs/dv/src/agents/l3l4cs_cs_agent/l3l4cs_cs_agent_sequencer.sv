// -------------------------------------------------------------------------
// File name		: l3l4cs_cs_agent_sequencer.sv 
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
`ifndef CS_AGENT_SEQUENCER_SV
    `define CS_AGENT_SEQUENCER_SV
    
    class cs_agent_sequencer#(type ITM=cs_agent_item) extends ce_base_sequencer#(ITM);
        `uvm_component_param_utils(cs_agent_sequencer#(ITM))
        function new(input string name, input uvm_component parent);
            super.new(name, parent);
        endfunction
    endclass
`endif // CS_AGENT_SEQUENCER_SV
