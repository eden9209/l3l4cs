`ifndef  AXI_WRAP_MONITOR_SV
    `define  AXI_WRAP_MONITOR_SV

    class  axis_wrap_monitor#(
        type CFG =  axis_wrap_config,
        type ITM =  axis_wrap_item
    ) extends axis_vwrp_monitor#(CFG,ITM);

        `uvm_component_param_utils( axis_wrap_monitor #(CFG,ITM))

        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction : new

        virtual task do_mon();
            super.do_mon();
            if (m_config.mon_en[ACT]) begin
                m_item.data = m_config.m_vif.agent_if.act_data;
                m_item.valid= m_config.m_vif.agent_if.act_valid;
            end                                     
    
        endtask:do_mon



        virtual task start_cond(); 
        endtask:start_cond

    endclass :  axis_wrap_monitor
`endif //  AXI_WRAP_MONITOR_SV
