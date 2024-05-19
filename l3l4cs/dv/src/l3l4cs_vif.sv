`ifndef L3L4CS_VIF_SV
    `define L3L4CS_VIF_SV

    class l3l4cs_vif extends ce_base_vif;
        `uvm_object_utils(l3l4cs_vif)

        cs_agent_vif  m_cs_agent_vif;
	  //  axis_wrap_vif  m_axi_wrap_vif;

        axis_wrap_vif  m_axi_wrp_vif[`AXI_WRPS_NUM];



        function new(string name = "");
         super.new(name);

        m_cs_agent_vif = cs_agent_vif::type_id::create({child_name(0),"_vif"});
        
        foreach(m_axi_wrp_vif[axi_wrp_i]) begin
            m_axi_wrp_vif[axi_wrp_i] = axis_wrap_vif::type_id::create({child_name(axi_wrp_i),"_vif"});
        end

     //   m_axi_wrap_vif = axis_wrap_vif::type_id::create({child_name(0),"_vif"});

        endfunction : new
        function string child_name(int child_i);
        endfunction : child_name

    endclass : l3l4cs_vif 

`endif // L3L4CS_VIF_SV
