// -------------------------------------------------------------------------
// File name		: l3l4cs_cs_agent.sv 
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
`ifndef  CS_AGENT_SV
`define  CS_AGENT_SV

    class cs_agent
        extends ce_base_agent#(
            cs_agent_item,
            cs_agent_config,
            cs_agent_monitor,
            cs_agent_driver,
            cs_agent_sequencer,
            cs_agent_data_seq,
            cs_agent_scbd,  
            cs_agent_coverage,
            `CS_AGENT_STREMAS);

        `uvm_component_utils(cs_agent)

        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction : new

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            m_config.cov_en=1;
        endfunction : build_phase

        function void connect_phase(uvm_phase phase);
            `uvm_info(get_name(), "In connect_phase", UVM_DEBUG)
            super.connect_phase(phase);
            
    if (!uvm_config_db#(l3l4cs_global)::get(this, "*", "global", m_config.m_global))
    begin
        `uvm_error(get_type_name(), "config not found")
    end

      endfunction : connect_phase

endclass :  cs_agent
`endif //  CS_AGENT_SV

