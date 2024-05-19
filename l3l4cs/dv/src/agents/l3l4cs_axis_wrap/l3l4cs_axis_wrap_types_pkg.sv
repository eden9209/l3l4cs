`ifndef AXI_WRAP_TYPES_PKG_SV
`define AXI_WRAP_TYPES_PKG_SV
    package  l3l4cs_axis_wrap_types_pkg;
        `include "uvm_macros.svh"
        import uvm_pkg::*;
        import gk_base_types_pkg::*;


        typedef enum {	
            AXI_IN                        ,// 0
            AXI_OUT                        // 1
        
        }axi_wrp_t;

       

    endpackage :  l3l4cs_axis_wrap_types_pkg
`endif // AXI_WRAP_TYPES_PKG_SV
