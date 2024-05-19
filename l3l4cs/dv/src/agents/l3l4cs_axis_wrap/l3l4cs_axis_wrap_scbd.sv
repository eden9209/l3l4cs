
`ifndef AXI_WRAP_SCBD_SV
    `define AXI_WRAP_SCBD_SV
    class axis_wrap_scbd #(
        type CFG = axis_wrap_config, 
        type ITM = axis_wrap_item
    ) extends axis_vwrp_scbd#(CFG,ITM);

        `uvm_component_param_utils(axis_wrap_scbd#(CFG,ITM))
        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction: new
    endclass : axis_wrap_scbd 
    ////////////////////////////////////////
`endif // AXI_WRAP_SCBD_SV
