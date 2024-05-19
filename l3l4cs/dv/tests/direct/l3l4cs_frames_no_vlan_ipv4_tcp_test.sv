  
  class l3l4cs_frames_no_vlan_ipv4_tcp_test_eth_item extends eth_p_agent_item;
    `uvm_object_utils(l3l4cs_frames_no_vlan_ipv4_tcp_test_eth_item)

    parameter int FRAMES_NUM=4;
    int direct_id;
    bit[7:0] type_len[3][2]='{'{0,0},`ETH_IPV6_Q,`ETH_IPV4_Q};


    function new(string name = "");
      super.new(name);
  endfunction : new

  function void pre_try_randomize(int item_id);
    direct_id=item_id%FRAMES_NUM;
endfunction : pre_try_randomize

//   constraint direct_eth_item_co{
//     L2.F.field[L2_TAG].size()==  frames_no_vlan_ipv4_tcp [direct_id][0][0]*4;        
//    // `constraint_q(L2.F.field[L2_TAG],frames_no_vlan_ipv4_tcp [direct_id][1])
//     //`constraint_q(L2.F.field[L2_TYPE_LEN],type_len[2])

//  //   2048==L2.type_len;  
//    // 17== L2.L3.protocol;   
//  //  `constraint_q(L2.F.field[L2_TYPE_LEN],frames_no_vlan_ipv4_tcp [direct_id][2][0])
//    // `constraint_q(L2.L3.F.field[L3V4_PROTOCOL],frames_no_vlan_ipv4_tcp [direct_id][3])
//    // `constraint_q(L2.L3.F.field[L3V4_PROTOCOL],ETH_UDP)
//     L2.L3.L4.L5.pdu_payload_type==pdu_payload_types_t'(TO_PDU);
//   }//direct_eth_item_co    
   
endclass : l3l4cs_frames_no_vlan_ipv4_tcp_test_eth_item


class l3l4cs_frames_no_vlan_ipv4_tcp_test_eth_data_seq extends eth_p_agent_data_seq;
  `uvm_object_utils(l3l4cs_frames_no_vlan_ipv4_tcp_test_eth_data_seq)

  function new(string name = "");
    super.new(name);
endfunction : new

task body();
    super.body();
endtask :body 

function void randomize_item(int item_id);

   super.randomize_item(item_id);
 
  m_item.L2.L3.F.field_ilegal[L3V4_HEADER_CHECKSUM] =frames_no_vlan_ipv4_tcp [item_id][4][0]; 
  m_item.L2.L3.L4.F.field_ilegal[L4_CHECKSUM] =  frames_no_vlan_ipv4_tcp [item_id][5][0]; ;
   m_item.pack();
`uvm_info(get_name(),m_item.get_string(),UVM_HIGH)

endfunction : randomize_item

endclass : l3l4cs_frames_no_vlan_ipv4_tcp_test_eth_data_seq



class l3l4cs_frames_no_vlan_ipv4_tcp_test_config extends l3l4cs_test_config;
  `uvm_object_utils(l3l4cs_frames_no_vlan_ipv4_tcp_test_config)

  constraint items_num_co{
		m_axi_wrap_config[AXI_IN ].m_eth_agent_config.items_num==4;
	}//items_num_co     

   function new(string name = "");  
      super.new(name);
   endfunction : new
endclass: l3l4cs_frames_no_vlan_ipv4_tcp_test_config

class l3l4cs_frames_no_vlan_ipv4_tcp_test extends l3l4cs_test;
  `uvm_component_utils(l3l4cs_frames_no_vlan_ipv4_tcp_test)
  extern         function       new(string name, uvm_component parent);
  extern virtual function void  set_config();
  extern virtual function void  set_sequences();
endclass : l3l4cs_frames_no_vlan_ipv4_tcp_test
//////////////////////////////////////////////////////////////////////
function l3l4cs_frames_no_vlan_ipv4_tcp_test::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new
  
//////////////////////////////////////////////////////////////////////
function void l3l4cs_frames_no_vlan_ipv4_tcp_test::set_config();
  super.set_config();
  l3l4cs_config ::type_id::set_type_override(l3l4cs_frames_no_vlan_ipv4_tcp_test_config::get_type());    
endfunction : set_config
//////////////////////////////////////////////////////////////////////
function void l3l4cs_frames_no_vlan_ipv4_tcp_test::set_sequences();   
  super.set_sequences();
  eth_p_agent_item::type_id::set_type_override(l3l4cs_frames_no_vlan_ipv4_tcp_test_eth_item::get_type());
  eth_p_agent_driver::type_id::set_type_override(eth_cs_agent_driver::get_type());
  eth_p_agent_data_seq::type_id::set_type_override(l3l4cs_frames_no_vlan_ipv4_tcp_test_eth_data_seq::get_type());

endfunction : set_sequences
//////////////////////////////////////////////////////////////////////
//`endif // l3l4cs_frames_no_vlan_ipv4_tcp_test



