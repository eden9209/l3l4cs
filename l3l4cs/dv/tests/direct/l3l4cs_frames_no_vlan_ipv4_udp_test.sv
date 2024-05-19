    
  class l3l4cs_frames_no_vlan_ipv4_udp_test_eth_item extends eth_p_agent_item;
    `uvm_object_utils(l3l4cs_frames_no_vlan_ipv4_udp_test_eth_item)

    parameter int FRAMES_NUM=25;
    int direct_id;
    int first_item_id;

    typedef enum int {
      _VLANS        ,//  0  
      _ETHERTYPE    ,//  1
      _PROTOCOL     ,//  2
      _L2_PAYLOAD   ,//  3
      _L3_PAYLOAD   ,//  4
      _L4_PAYLOAD   ,//  5
      _L5_PAYLOAD   ,//  6
      _PASSTHROUGH  ,//  7
      _CHOP         ,//  8
      _OPTIONS      ,//  9
      _PADD         ,// 10
      TABLE_COL_SNTL // 10
  } table_col_t;  

    function new(string name = "");
      super.new(name);
  endfunction : new

  function void pre_randomize();
    super.pre_randomize();
endfunction : pre_randomize


  function void pre_try_randomize(int item_id);
    super.pre_try_randomize(item_id);
    direct_id=first_item_id+item_id%FRAMES_NUM;
endfunction : pre_try_randomize

virtual function void pack();
  super.pack();
  `uvm_info(get_name(), $sformatf("pack item %0s",get_string()),UVM_DEBUG)        
endfunction: pack  

constraint direct_eth_item_co{
  L2.L3.L4.L5.pdu_payload_type ==TO_PDU;
  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  if(direct_frames_table[direct_id][_VLANS     ]>=0)   direct_frames_table[direct_id][_VLANS  ]*4 ==L2.F.field[L2_TAG].size;//each vlan needs 4B
  if(direct_frames_table[direct_id][_ETHERTYPE ]>=0)   direct_frames_table[direct_id][_ETHERTYPE ]==L2.type_len;                            
  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  if(direct_frames_table[direct_id][_PROTOCOL  ]>=0)   direct_frames_table[direct_id][_PROTOCOL  ]== L2.L3.protocol;                   
  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  if(direct_frames_table[direct_id][_L2_PAYLOAD]>=0)   direct_frames_table[direct_id][_L2_PAYLOAD]==L2.F.field[L2_PAYLOAD].size;
  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  if(direct_frames_table[direct_id][_L3_PAYLOAD]>=0)   direct_frames_table[direct_id][_L3_PAYLOAD]==L2.L3.payload.size;
  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  if(direct_frames_table[direct_id][_L4_PAYLOAD]>=0)   direct_frames_table[direct_id][_L4_PAYLOAD]==L2.L3.L4.F.field[L4_PAYLOAD].size;
  if(direct_frames_table[direct_id][_L5_PAYLOAD]>=0)   direct_frames_table[direct_id][_L5_PAYLOAD]==L2.L3.L4.L5.F.field[L5_PAYLOAD].size;
  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  if(direct_frames_table[direct_id][_CHOP      ]>=0)   direct_frames_table[direct_id][_CHOP]      ==F.chop_idx[FINISH];
  if(direct_frames_table[direct_id][_CHOP      ]<-1)   direct_frames_table[direct_id][_CHOP]*(-1) ==F.chop_idx[START];
  if(direct_frames_table[direct_id][_PADD      ]>=0)   direct_frames_table[direct_id][_PADD]      ==L2.F.field[L2_PADDING].size;
  if(direct_frames_table[direct_id][_OPTIONS   ]>0 &&                                               
      L2.type_len==ETH_IPV4)                           direct_frames_table[direct_id][_OPTIONS]   == L2.L3.F.field[L3V4_OPTIONS].size;
  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
}//direct_eth_item_co    s


  // constraint direct_eth_item_co{

  //   TO_PDU== L2.L3.L4.L5.pdu_payload_type;
  //   frames_no_vlan_ipv4_udp[direct_id][0] == L2.F.field[L2_TAG].size;//each vlan needs 4B
  //   frames_no_vlan_ipv4_udp[direct_id][1] == L2.type_len;                            
  //   frames_no_vlan_ipv4_udp[direct_id][2] == L2.L3.protocol;   
  //   frames_no_vlan_ipv4_udp[direct_id][3] == L2.L3.F.field_ilegal[L3V4_HEADER_CHECKSUM];
  //   frames_no_vlan_ipv4_udp[direct_id][4] == L2.L3.L4.F.field_ilegal[L4_CHECKSUM];

  //  }//direct_eth_item_co    
  
   
endclass : l3l4cs_frames_no_vlan_ipv4_udp_test_eth_item


// int frames_no_vlan_ipv4_udp[4][5][]='{
//   // id //   | 0          | 1                |2                |3             |4
//   // id //   |VLANS       | L2_TYPE_LEN      |L3_PROTOCOL      |B_G_cs_L3     |B_G_cs_L4
// //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//   /*  0 */ '{ 0,          ETH_IPV4,          ETH_UDP,              0,               0    }, //  /* 0*/ "No VLAN IPV4-UDP CORRECT cs L3 ,CORRECT cs L4"
//   /*  1 */ '{ 0,          ETH_IPV4,          ETH_UDP,              1,               0    }, //  /* 1*/ "No VLAN IPV4-UDP  WRONG cs  L3 ,CORRECT cs L4"
//   /*  2 */ '{ 0,          ETH_IPV4,          ETH_UDP,              0,               1    }, //  /* 2*/ "No VLAN IPV4-UDP  CORRECT cs L3 , WRONG cs L4"
//   /*  3 */ '{ 0,          ETH_IPV4,          ETH_UDP,              1,               1    }  //  /* 3*/ "No VLAN IPV4-UDP  WRONG cs L3 , WRONG cs L4"
// };         
//`constraint_q(L2.L3.F.field[L3V4_PROTOCOL],frames_with_vlan_ipv4_tcp [direct_id][3])
////
// class l3l4cs_frames_no_vlan_ipv4_udp_test_eth_data_seq extends eth_p_agent_data_seq;
//   `uvm_object_utils(l3l4cs_frames_no_vlan_ipv4_udp_test_eth_data_seq)

//   function new(string name = "");
//     super.new(name);
// endfunction : new

// task body();
//     super.body();
// endtask :body 

// function void randomize_item(int item_id);

//    super.randomize_item(item_id);
 
//   m_item.L2.L3.F.field_ilegal[L3V4_HEADER_CHECKSUM] =frames_no_vlan_ipv4_udp [item_id][4][0]; 
//   m_item.L2.L3.L4.F.field_ilegal[L4_CHECKSUM] =  frames_no_vlan_ipv4_udp [item_id][5][0]; ;
//    m_item.pack();
// `uvm_info(get_name(),m_item.get_string(),UVM_HIGH)

// endfunction : randomize_item

// endclass : l3l4cs_frames_no_vlan_ipv4_udp_test_eth_data_seq




class l3l4cs_frames_no_vlan_ipv4_udp_test_config extends l3l4cs_test_config;
  `uvm_object_utils(l3l4cs_frames_no_vlan_ipv4_udp_test_config)

  constraint items_num_co{
		m_axi_wrap_config[AXI_IN ].m_eth_agent_config.items_num==25;
    m_axi_wrap_config[AXI_IN ].items_num==0;
    m_cs_agent_config.items_num==25;

//		m_cs_agent_config.items_num==25;
  	}//items_num_co     

   function new(string name = "");  
      super.new(name);
   endfunction : new
endclass: l3l4cs_frames_no_vlan_ipv4_udp_test_config

class l3l4cs_frames_no_vlan_ipv4_udp_test extends l3l4cs_test;
  `uvm_component_utils(l3l4cs_frames_no_vlan_ipv4_udp_test)
  extern         function       new(string name, uvm_component parent);
  extern virtual function void  set_config();
  extern virtual function void  set_sequences();
endclass : l3l4cs_frames_no_vlan_ipv4_udp_test
//////////////////////////////////////////////////////////////////////
function l3l4cs_frames_no_vlan_ipv4_udp_test::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new
  
//////////////////////////////////////////////////////////////////////
function void l3l4cs_frames_no_vlan_ipv4_udp_test::set_config();
  super.set_config();
  l3l4cs_config ::type_id::set_type_override(l3l4cs_frames_no_vlan_ipv4_udp_test_config::get_type());    
endfunction : set_config
//////////////////////////////////////////////////////////////////////
function void l3l4cs_frames_no_vlan_ipv4_udp_test::set_sequences();   
  super.set_sequences();
  eth_p_agent_item::type_id::set_type_override(l3l4cs_frames_no_vlan_ipv4_udp_test_eth_item::get_type());
  eth_p_agent_driver::type_id::set_type_override(eth_cs_agent_driver::get_type());
 // eth_p_agent_data_seq::type_id::set_type_override(l3l4cs_frames_no_vlan_ipv4_udp_test_eth_data_seq::get_type());

endfunction : set_sequences
//////////////////////////////////////////////////////////////////////
//`endif // l3l4cs_frames_no_vlan_ipv4_udp_test



