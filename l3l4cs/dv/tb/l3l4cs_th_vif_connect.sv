	 vif.m_cs_agent_vif.agent_if= cs_agent_if;

	//   vif.m_axi_wrap_vif.agent_if=am_vip;
	//   vif.m_axi_wrap_vif.m_eth_agent_vif.agent_if=eth_vip_if1;


	  vif.m_axi_wrp_vif[AXI_IN ].agent_if                = gen_axi[AXI_IN ].axis_wrap_if;
	  vif.m_axi_wrp_vif[AXI_IN ].m_eth_agent_vif.agent_if= gen_axi[AXI_IN ].eth_wrp_if;
	  vif.m_axi_wrp_vif[AXI_OUT].agent_if                = gen_axi[AXI_OUT].axis_wrap_if;
	  vif.m_axi_wrp_vif[AXI_OUT].m_eth_agent_vif.agent_if= gen_axi[AXI_OUT].eth_wrp_if;

