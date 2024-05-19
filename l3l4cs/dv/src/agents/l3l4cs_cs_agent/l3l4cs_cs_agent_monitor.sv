// -------------------------------------------------------------------------
// File name		: l3l4cs_cs_agent_monitor.sv 
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
`ifndef  CS_AGENT_MONITOR_SV
    `define  CS_AGENT_MONITOR_SV
    class  cs_agent_monitor#(
        type CFG =  cs_agent_config,
        type ITM =  cs_agent_item
    ) extends ce_base_monitor#(CFG,ITM);

        `uvm_component_param_utils( cs_agent_monitor #(CFG,ITM))

        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction : new


        
        virtual task main_do_mon();
            m_config.wait_clk();

            super.main_do_mon();
            
          wait(m_config.m_vif.agent_if.checksum_valid_o == 1'b1);
            if (m_config.mon_en[ACT]) begin
            m_item.checksum_valid_o= m_config.m_vif.agent_if.checksum_valid_o;
            m_item.l3_checksum_o= m_config.m_vif.agent_if.l3_checksum_o;
            m_item.l4_checksum_o= m_config.m_vif.agent_if.l4_checksum_o;
            m_item.length_error_o= m_config.m_vif.agent_if.length_error_o;
             m_item.cnt+=1;
            end                           
        endtask:main_do_mon

        virtual function bit break_cond();
            if(m_config.items_num == m_item.cnt)
            begin
             return(1);
            end
            else 
            begin
            return(0);
            end
        endfunction:break_cond


       virtual task start_cond(); 
        endtask:start_cond
 
    endclass :  cs_agent_monitor
`endif //  CS_AGENT_MONITOR_SV


