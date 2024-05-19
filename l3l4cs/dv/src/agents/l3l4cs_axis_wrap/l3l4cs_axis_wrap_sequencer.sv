`ifndef AXI_WRAP_SEQUENCER_SV
    `define AXI_WRAP_SEQUENCER_SV
    class axis_wrap_sequencer#(type ITM=axis_wrap_item) extends axis_vwrp_sequencer#(ITM);
        `uvm_component_param_utils(axis_wrap_sequencer#(ITM))
        function new(input string name, input uvm_component parent);
            super.new(name, parent);
        endfunction
    endclass
`endif // AXI_WRAP_SEQUENCER_SV
