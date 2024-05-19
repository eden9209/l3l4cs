`ifndef AXI_WRAP_PKG_SV
    `define AXI_WRAP_PKG_SV
    package  l3l4cs_axis_wrap_pkg;
        `include "uvm_macros.svh"
        `include "l3l4cs_axis_wrap_defines.sv"
        import uvm_pkg::*;
        
        import gk_base_types_pkg::*;
        import gk_base_pkg::*;
        import gk_base_global_pkg::*;
        import ce_base_types_pkg::*;
        import ce_base_pkg::*;



        import axis_vwrp_pkg::*;
        import l3l4cs_global_pkg::*;
        import l3l4cs_axis_wrap_types_pkg::*;
        import eth_p_agent_pkg::*;
        import l3l4cs_cs_agent_pkg::*;
        import eth_vip_pkg::*;

        import eth_vip_types_pkg::*;

        `include "l3l4cs_axis_wrap_item.sv"

        `include "l3l4cs_axis_wrap_vif.sv"
        `include "l3l4cs_axis_wrap_config.sv"
        `include "l3l4cs_axis_wrap_seq_lib.sv"
        `include "l3l4cs_axis_wrap_driver.sv"
        `include "l3l4cs_axis_wrap_monitor.sv"
        `include "l3l4cs_axis_wrap_sequencer.sv"
        `include "l3l4cs_axis_wrap_coverage.sv"
        `include "l3l4cs_axis_wrap_scbd.sv"

        `include "l3l4cs_axis_wrap.sv"
    endpackage :  l3l4cs_axis_wrap_pkg
    /////////////////////////////////////////
`endif // AXI_WRAP_PKG_SV

