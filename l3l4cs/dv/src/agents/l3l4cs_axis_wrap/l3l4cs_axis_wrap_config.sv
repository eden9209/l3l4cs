`ifndef AXI_WRAP_CONFIG_SV
    `define AXI_WRAP_CONFIG_SV
    
    class axis_wrap_config extends axis_vwrp_config#(axis_wrap_vif,l3l4cs_global,axis_wrap_item,1);
        `uvm_object_utils(axis_wrap_config)

    //    l3l4cs_global m_global;
    //     bit tuser_error;
    //     rand bit tlast_begin_of_frame;
    //     rand bit tlast_mid_L3;
    //     rand bit tlast_mid_L4;

     
        function new(string name = "");
            super.new(name);
        endfunction : new
    endclass : axis_wrap_config

`endif // AXI_WRAP_CONFIG_SV

