
`ifndef L3L4CS_ENV_SV
`define L3L4CS_ENV_SV

class l3l4cs_env extends ce_base_env#(l3l4cs_config);

   `uvm_component_utils(l3l4cs_env) 
    cs_agent m_cs_agent;
    axis_wrap m_axi_wrap[`AXI_WRPS_NUM];
    l3l4cs_default_seq vseq;

    function new(string name, uvm_component parent);
        super.new(name, parent);  
    endfunction : new

    function void build_phase(uvm_phase phase);
        `uvm_info(get_name(), "In build_phase", UVM_HIGH)
        super.build_phase(phase);
        
    if (m_config.cs_agent_build_en) begin
        uvm_config_db #(cs_agent_config)::set(this, {m_config.cs_agent_name(0),"*"},"config", m_config.m_cs_agent_config);
        m_cs_agent  = cs_agent::type_id::create(m_config.cs_agent_name(0), this);
        m_config.m_cs_agent_config.m_vif = m_config.m_vif.m_cs_agent_vif;
      end// m_cs_agent

      foreach(m_axi_wrap[axi_wrp_i]) begin
        uvm_config_db #(axis_wrap_config)::set(this, {m_config.axi_wrp_name(axi_wrp_i),"*"},"config", m_config.m_axi_wrap_config[axi_wrp_i]);
        m_axi_wrap[axi_wrp_i]  = axis_wrap::type_id::create(m_config.axi_wrp_name(axi_wrp_i), this);
        m_config.m_axi_wrap_config[axi_wrp_i].m_vif = m_config.m_vif.m_axi_wrp_vif[axi_wrp_i];
    end// foreach(m_axi_wrp[axi_wrp_i])

        // uvm_config_db #(axis_wrap_config)::set(this, {m_config.axi_wrap_name(0),"*"},"config", m_config.m_axi_wrap_config);
        // m_axi_wrap  = axis_wrap::type_id::create(m_config.axi_wrap_name(0), this);
        // m_config.m_axi_wrap_config.m_vif = m_config.m_vif.m_axi_wrap_vif;

    endfunction : build_phase

  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    function void connect_phase(uvm_phase phase);
            eth_cs_agent_driver drv_cs;
            
            `uvm_info(get_name(), "In connect_phase", UVM_HIGH)
            super.connect_phase(phase);
            
            if($cast(drv_cs,m_axi_wrap[AXI_IN ].m_eth_agent.m_driver))
            drv_cs.analysis_port_cs.connect(m_cs_agent.m_scbd[0].item_fifo[EXP].analysis_export);
            
    endfunction : connect_phase
  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    task run_phase(uvm_phase phase);
        `uvm_info(get_name(),$psprintf("Entering run_phase"), UVM_LOW)
        phase.raise_objection(.obj(this));

        vseq = l3l4cs_default_seq::type_id::create("l3l4cs_virtual_sequencer");
        vseq.set_starting_phase(phase);
        vseq.set_item_context(null, null);
        vseq_connect();  
        vseq.start(null);
        phase.drop_objection(.obj(this));

    endtask : run_phase
  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    virtual function void vseq_connect();
        vseq.m_config =m_config; 
    	  vseq.m_cs_agent=m_cs_agent;
        vseq.m_axi_wrap=m_axi_wrap;

    endfunction: vseq_connect

endclass : l3l4cs_env 
////////////////////////////////////////////////////
`endif // L3L4CS_ENV_SV

