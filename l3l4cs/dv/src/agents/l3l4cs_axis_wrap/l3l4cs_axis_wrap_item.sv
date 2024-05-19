`ifndef AXI_WRAP_TRANS_SV
    `define AXI_WRAP_TRANS_SV
    class axis_wrap_item extends axis_vwrp_item; 
        `uvm_object_utils(axis_wrap_item)
        int time_to_stop;

        extern          function new(string name = "");
      endclass : axis_wrap_item 


    function axis_wrap_item::new(string name = "");
        super.new(name);
    endfunction : new










    
`endif // AXI_WRAP_TRANS_SV
