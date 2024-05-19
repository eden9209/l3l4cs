`ifndef L3L4CS_SEQ_LIB_SV
`define L3L4CS_SEQ_LIB_SV

    class l3l4cs_default_seq extends ce_base_default_seq#(l3l4cs_config);

        `uvm_object_utils(l3l4cs_default_seq)

        cs_agent m_cs_agent;
        axis_wrap m_axi_wrap[`AXI_WRPS_NUM];;
       
        function new(string name = "");
            super.new(name);
        endfunction : new

        task pre_start();
            uvm_phase phase = get_starting_phase();
            if (phase != null)
                phase.raise_objection(this);
        endtask: pre_start

        
        task post_start();
            uvm_phase phase = get_starting_phase();
            if (phase != null) 
                phase.drop_objection(this);
        endtask: post_start

        task pre_body();
            super.pre_body();
            assert (m_config != null) else
                `uvm_fatal(get_name(), "m_config not defined");   
        endtask : pre_body

        task body();
            super.body();
          //  m_config.wait_Xclk(100);

         fork 
	     	 axi_wrap_seq_call();
         join
            m_config.wait_Xclk(1);

        endtask : body

        function void undefined_agent_info(string agent_name);
            `uvm_info(get_name(),$sformatf("%0s is not defined! Please set a pointer for sub-childs vector",agent_name),UVM_HIGH)
        endfunction: undefined_agent_info

        
        task cs_agent_seq_call();
            if (m_cs_agent==null)
                undefined_agent_info(m_config.cs_agent_name(0));
            else
                if(cs_agent_seq_cond(0))
                m_cs_agent.agent_seq_call(get_starting_phase());
        `uvm_info(get_name(),$sformatf("cs_agent_seq_call done"), UVM_HIGH)
        endtask : cs_agent_seq_call
        
        function bit cs_agent_seq_cond(int cs_agent_i);
            bit cond;
            cond |= 1;
            cond &= (m_config.m_cs_agent_config.drv_en>0);
            return(cond);
        endfunction: cs_agent_seq_cond
        
        // task axi_wrap_seq_call();
        //     foreach (m_axi_wrap[i]) begin
        //         automatic int axi_wrap_i =i;
        //         fork
        //         if (m_axi_wrap[axi_wrap_i]==null)
        //         undefined_agent_info(m_config.axi_wrp_name(axi_wrap_i));
        //         else
        //         fork
        //             if(axi_wrap_seq_cond(axi_wrap_i))
        //                 m_axi_wrap[axi_wrap_i].agent_seq_call(get_starting_phase());
        //         join_none // non-blocking thread
        //     end
        //     wait fork; // wait for all forked threads in current scope to end
        // `uvm_info(get_name(),$sformatf("axi_wrap_seq_call done"), UVM_HIGH)
        // endtask : axi_wrap_seq_call


        // task axi_wrap_seq_call();
        //     foreach (m_axi_wrap[i]) begin
        //     automatic int axi_wrap_i =i;
        //     fork
        //         if(axi_wrap_seq_cond(axi_wrap_i)) begin
        //             if (m_axi_wrap[axi_wrap_i]==null)
        //                 undefined_agent_info(m_config.axi_wrp_name(axi_wrap_i));
        //             else
        //             m_axi_wrap[axi_wrap_i].agent_seq_call(get_starting_phase());
        //             end//axi_agent_seq_cond
        //         join_none // non-blocking thread
        //     end// foreach(axi_agent[i])
        //     wait fork; // wait for all forked threads in current scope to end
        //     `uvm_info(get_name(),$sformatf("axi_wrap_agent_seq_call done"), UVM_HIGH)
        // endtask : axi_wrap_seq_call


        task axi_wrap_seq_call();
            uvm_phase phase=get_starting_phase();
            foreach (m_axi_wrap[i]) begin
                automatic int axi_wrp_i =i;
                if (m_axi_wrap[axi_wrp_i]==null)
                    undefined_agent_info(m_config.axi_wrp_name(axi_wrp_i));
                else
                    fork
                        if(axi_wrap_seq_cond(axi_wrp_i))
                        m_axi_wrap[axi_wrp_i].agent_seq_call(phase);
                    join_none // non-blocking thread
            end// foreach(axi_wrp[i])
            wait fork; // wait for all forked threads in current scope to end
            `uvm_info(get_name(),$sformatf("axi_wrp_seq_call done"), UVM_HIGH)
        endtask : axi_wrap_seq_call

        
        function bit axi_wrap_seq_cond(int axi_wrap_i);
            bit cond;
            cond = 1;
            cond &= (m_config.m_axi_wrap_config[axi_wrap_i].drv_en>0);
            return(cond);
        endfunction: axi_wrap_seq_cond
        
        
    endclass : l3l4cs_default_seq

 `endif // L3L4CS_SEQ_LIB_SV 

