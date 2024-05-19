// -------------------------------------------------------------------------
// File name		: l3l4cs_cs_agent_pkg.sv 
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

`ifndef CS_AGENT_PKG_SV
    `define CS_AGENT_PKG_SV
    package  l3l4cs_cs_agent_pkg;
        `include "uvm_macros.svh"
        `include "l3l4cs_cs_agent_defines.sv"
        import uvm_pkg::*;
        import gk_base_types_pkg::*;
        import gk_base_pkg::*;
        import ce_base_pkg::*;
        import l3l4cs_global_pkg::*;
        import l3l4cs_cs_agent_types_pkg::*;
        `include "l3l4cs_cs_agent_item.sv"
        `include "l3l4cs_cs_agent_vif.sv"
        `include "l3l4cs_cs_agent_config.sv"
        `include "l3l4cs_cs_agent_seq_lib.sv"
        `include "l3l4cs_cs_agent_driver.sv"
        `include "l3l4cs_cs_agent_monitor.sv"
        `include "l3l4cs_cs_agent_sequencer.sv"
        `include "l3l4cs_cs_agent_coverage.sv"
        `include "l3l4cs_cs_agent_scbd.sv"
        `include "l3l4cs_cs_agent.sv"
    endpackage :  l3l4cs_cs_agent_pkg
    /////////////////////////////////////////
`endif // CS_AGENT_PKG_SV

