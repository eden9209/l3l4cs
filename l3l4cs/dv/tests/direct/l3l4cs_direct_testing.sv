     
  class l3l4cs_direct_testing_eth_item extends eth_p_agent_item;
    `uvm_object_utils(l3l4cs_direct_testing_eth_item)

    parameter int FRAMES_NUM=12;
    int direct_id;
    int first_item_id;
    randc bit L3_checksum;
    randc bit L4_checksum;
  
    function new(string name = "");
      super.new(name);
  endfunction : new

  function void pre_randomize();
    super.pre_randomize();
endfunction : pre_randomize

function void pre_try_randomize(int item_id);
  super.pre_try_randomize(item_id);
  direct_id=first_item_id+item_id%FRAMES_NUM;
  L3_checksum = $random;
  L4_checksum=$random;
  L2.L3.L3_ihl_options_size_co.constraint_mode(0);

endfunction : pre_try_randomize

virtual function void pack();
  super.pack();
  `uvm_info(get_name(), $sformatf("pack item %0s",get_string()),UVM_DEBUG)        
endfunction: pack  

constraint direct_eth_item_co{
  
//  L2.L3.L4.L5.pdu_payload_type ==TO_PDU;
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
   

  if(direct_frames_table[direct_id][_IHL]>=0)   direct_frames_table[direct_id][_IHL]==L2.L3.F.field[L3V4_IHL][0][3:0];

  if(direct_frames_table[direct_id][_OPTIONS   ]>0 && L2.type_len==ETH_IPV4) direct_frames_table[direct_id][_OPTIONS]   == L2.L3.F.field[L3V4_OPTIONS].size;
  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
}//direct_eth_item_co 



constraint illegal_cs_L3_L4_co{
  L2.L3.L4.F.field_ilegal[L4_CHECKSUM] ==L4_checksum;
  L2.L3.F.field_ilegal[L3V4_HEADER_CHECKSUM]==L3_checksum;
}//illegal_cs_L3_L4_co
 
endclass : l3l4cs_direct_testing_eth_item


class l3l4cs_direct_testing_config extends l3l4cs_test_config;
  `uvm_object_utils(l3l4cs_direct_testing_config)

  constraint items_num_co{
		m_axi_wrap_config[AXI_IN ].m_eth_agent_config.items_num==12;
    m_axi_wrap_config[AXI_IN ].items_num==0;
    m_cs_agent_config.items_num==12;
  	}

   function new(string name = "");  
      super.new(name);
   endfunction : new
endclass: l3l4cs_direct_testing_config

class l3l4cs_direct_testing extends l3l4cs_test;
  `uvm_component_utils(l3l4cs_direct_testing)
  extern         function       new(string name, uvm_component parent);
  extern virtual function void  set_config();
  extern virtual function void  set_sequences();
endclass : l3l4cs_direct_testing
//////////////////////////////////////////////////////////////////////
function l3l4cs_direct_testing::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new
  
//////////////////////////////////////////////////////////////////////
function void l3l4cs_direct_testing::set_config();
  super.set_config();
  l3l4cs_config ::type_id::set_type_override(l3l4cs_direct_testing_config::get_type());    
endfunction : set_config
//////////////////////////////////////////////////////////////////////
function void l3l4cs_direct_testing::set_sequences();   
  super.set_sequences();
  eth_p_agent_item::type_id::set_type_override(l3l4cs_direct_testing_eth_item::get_type());
  eth_p_agent_driver::type_id::set_type_override(eth_cs_agent_driver::get_type());

endfunction : set_sequences
//////////////////////////////////////////////////////////////////////
//`endif // l3l4cs_dricted_testing



