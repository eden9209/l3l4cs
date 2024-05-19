`ifndef AXI_WRAP_VIF_SV
    `define AXI_WRAP_VIF_SV
    class axis_wrap_vif extends axis_vwrp_vif#(virtual axis_wrap_if);
        `uvm_object_utils( axis_wrap_vif)

        extern function new(string name = "");
    endclass :   axis_wrap_vif

    function  axis_wrap_vif::new(string name = "");
        super.new(name);
    endfunction : new
`endif//  AXI_WRAP_IF_SV
