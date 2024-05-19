// -------------------------------------------------------------------------
// File name		: l3l4cs_cs_agent_types_pkg.sv 
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
`ifndef CS_AGENT_TYPES_PKG_SV
`define CS_AGENT_TYPES_PKG_SV
    package  l3l4cs_cs_agent_types_pkg;
        `include "uvm_macros.svh"
        import uvm_pkg::*;
        import gk_base_types_pkg::*;
        import ce_base_types_pkg::*;
        typedef enum {	
            	CS_OUT                         // 0

        }cs_agent_t;
      
    endpackage :  l3l4cs_cs_agent_types_pkg
`endif // CS_AGENT_TYPES_PKG_SV
