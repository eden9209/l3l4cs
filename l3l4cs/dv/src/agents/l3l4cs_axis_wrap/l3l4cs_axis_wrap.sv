`ifndef  AXI_WRAP_SV
`define  AXI_WRAP_SV
    class axis_wrap
        extends axis_vwrp#(
            axis_wrap_item,
            axis_wrap_config,
            axis_wrap_monitor,
            axis_wrap_driver,
            axis_wrap_sequencer,
            axis_wrap_data_seq,
            axis_wrap_scbd,  
            axis_wrap_coverage,
            `AXI_WRP_STREAMS);

        `uvm_component_utils(axis_wrap)

      function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        // m_config.cov_en=1;
        // m_config.m_eth_agent_config.cov_en=1;
     endfunction : build_phase


        function void connect_phase(uvm_phase phase);
            `uvm_info(get_name(), "In connect_phase", UVM_DEBUG)
            super.connect_phase(phase);

         if (!uvm_config_db#(l3l4cs_global)::get(this, "*", "global", m_config.m_global))
         begin
        `uvm_error(get_type_name(), "config not found")
          end
          
        endfunction : connect_phase


        function new(string name, uvm_component parent);
            super.new(name, parent);

        endfunction : new

endclass :  axis_wrap
`endif //  AXI_WRAP_SV

