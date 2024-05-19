   
   cs_agent_if  cs_agent_if(.clk(clk), .reset_n(reset_n));
   axi_stream_if #(.DWIDTH(8)) axi_master_dut (.clk(clk), .reset_n(reset_n));
   axi_stream_if #(.DWIDTH(8)) axi_slave_dut (.clk(clk), .reset_n(reset_n));
   markers_t mrk_dut;
   logic[ETH_MRK_SNTL-1:0] l4m_markers; 


   generate
    for (genvar AXI_WRP_IDX=0; AXI_WRP_IDX<`AXI_WRPS_NUM; AXI_WRP_IDX++) begin : gen_axi
        eth_vip_if  eth_wrp_if(.clk(clk), .reset_n(reset_n));
        axis_wrap_if  axis_wrap_if(.clk(clk), .reset_n(reset_n));
    end
endgenerate

    
always_comb begin
    assign axi_slave_dut.tvalid  =l3l4cs_th.gen_axi[AXI_IN].axis_wrap_if.act_valid;
    assign axi_slave_dut.tlast   =gen_axi[AXI_IN ].axis_wrap_if.act_last ;
    assign axi_slave_dut.tdata   =gen_axi[AXI_IN ].axis_wrap_if.act_data ;
    assign axi_slave_dut.tuser   =gen_axi[AXI_IN ].axis_wrap_if.act_user ;
    assign gen_axi[AXI_IN ].axis_wrap_if.act_ready =axi_slave_dut.tready ;
    assign gen_axi[AXI_IN ].axis_wrap_if.act_user_slv =axi_slave_dut.tuser_slv ;
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    assign  gen_axi[AXI_OUT].axis_wrap_if.act_valid  = axi_master_dut.tvalid;
    assign  gen_axi[AXI_OUT].axis_wrap_if.act_data   = axi_master_dut.tdata ;
    assign  gen_axi[AXI_OUT].axis_wrap_if.act_last   = axi_master_dut.tlast ;
    assign  gen_axi[AXI_OUT].axis_wrap_if.act_user   = axi_master_dut.tuser ;
    assign  gen_axi[AXI_IN ].axis_wrap_if.act_user_slv = axi_master_dut.tuser_slv;
    assign  gen_axi[AXI_IN ].axis_wrap_if.act_ready  = axi_master_dut.tready;
end


initial begin
  force  axi_slave_dut.tready    = 1;
  force  axi_master_dut.tready    = 1;
 // force  axi_master_dut.tuser_slv    = 1;
end//initial


always_comb begin
  l4m_markers=gen_axi[AXI_IN].axis_wrap_if.act_mrks;
end

  

  always_comb begin
     mrk_dut.destination_mac_marker= l4m_markers[ETH_MRK_DESTINATION_MAC];                    
     mrk_dut.source_mac_marker= l4m_markers[ETH_MRK_SOURCE_MAC];
     mrk_dut.vlan_marker=l4m_markers[ETH_MRK_VLAN];
     mrk_dut.ethertype_marker=l4m_markers[ETH_MRK_ETHERTYPE];
     mrk_dut.arp_marker=l4m_markers[ETH_MRK_ARP];
     mrk_dut.ptp_marker=l4m_markers[ETH_MRK_PTP];
     mrk_dut.redundancy_tag_marker=l4m_markers[ETH_MRK_REDUNDANCY_TAG];
     mrk_dut.ipv4_marker=l4m_markers[ETH_MRK_ETHERTYPE_IPV4];
     mrk_dut.total_length_ipv4_marker=l4m_markers[ETH_MRK_TOTAL_LENGTH_IPV4];
     mrk_dut.protocol_ipv4_marker=l4m_markers[ETH_MRK_PROTOCOL_IPV4];
     mrk_dut.header_checksum_marker=l4m_markers[ETH_MRK_HEADER_CHECKSUM];
     mrk_dut.source_ipv4_marker=l4m_markers[ETH_MRK_SOURCE_IPV4];
     mrk_dut.destination_ipv4_marker=l4m_markers[ETH_MRK_DESTINATION_IPV4];
     mrk_dut.ipv6_marker=l4m_markers[ETH_MRK_ETHERTYPE_IPV6];
     mrk_dut.total_length_ipv6_marker=l4m_markers[ETH_MRK_TOTAL_LENGTH_IPV6];
     mrk_dut.next_header_marker=l4m_markers[ETH_MRK_NEXT_HEADER];
     mrk_dut.source_ipv6_marker=l4m_markers[ETH_MRK_SOURCE_IPV6];
     mrk_dut.destination_ipv6_marker=l4m_markers[ETH_MRK_DESTINATION_IPV6];
     mrk_dut.udp_source_port_marker=l4m_markers[ETH_MRK_UDP_SOURCE_PORT];
     mrk_dut.udp_destination_port_marker=l4m_markers[ETH_MRK_UDP_DESTINATION_PORT];
     mrk_dut.udp_total_length_marker=l4m_markers[ETH_MRK_UDP_TOTAL_LENGTH];
     mrk_dut.udp_checksum_marker=l4m_markers[ETH_MRK_UDP_CHECKSUM];
     mrk_dut.l4_payload_marker=l4m_markers[ETH_MRK_L4_PAYLOAD];
     mrk_dut.eof_marker=l4m_markers[ETH_MRK_EOF];
     mrk_dut.tcp_marker=l4m_markers[ETH_MRK_TCP];
     mrk_dut.sof_marker=l4m_markers[ETH_MRK_SOF];
     mrk_dut.layer2_marker=l4m_markers[ETH_MRK_LAYER2];
     mrk_dut.layer3_marker=l4m_markers[ETH_MRK_LAYER3];
     mrk_dut.layer4_marker=l4m_markers[ETH_MRK_LAYER4];
     mrk_dut.layer5_marker=l4m_markers[ETH_MRK_LAYER5];
     mrk_dut.passthrough_marker=l4m_markers[ETH_MRK_PASSTHROUGH];
    end



    
