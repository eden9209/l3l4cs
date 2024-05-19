  class l3l4cs_random_testing_eth_item extends eth_p_agent_item;
    `uvm_object_utils(l3l4cs_random_testing_eth_item)

    parameter int FRAMES_NUM=13;
    int direct_id;
    int first_item_id;
    rand bit wrong_good_cs_l3;
    rand bit wrong_good_cs_l4;
  
    function new(string name = "");
      super.new(name);
  endfunction : new

  function void pre_randomize();
    super.pre_randomize();
  endfunction : pre_randomize

  function void pre_try_randomize(int item_id);
    super.pre_try_randomize(item_id);
    direct_id=first_item_id+item_id%FRAMES_NUM;
    wrong_good_cs_l3=$urandom();
    wrong_good_cs_l4=$urandom();
  
  endfunction : pre_try_randomize

  virtual function void pack();
    super.pack();
    `uvm_info(get_name(), $sformatf("pack item %0s",get_string()),UVM_DEBUG)        
  endfunction: pack  
  
      constraint direct_eth_item_cs_co{
      wrong_good_cs_l3       == L2.L3.F.field_ilegal[L3V4_HEADER_CHECKSUM];
      wrong_good_cs_l4     == L2.L3.L4.F.field_ilegal[L4_CHECKSUM];
    
    }//direct_eth_item_cs_co 

    


    constraint direct_eth_item_co{
      L2.L3.L4.L5.pdu_payload_type ==TO_PDU;
      if(direct_frames_table[direct_id][_VLANS     ]>=0)   direct_frames_table[direct_id][_VLANS  ]*4 ==L2.F.field[L2_TAG].size;//each vlan needs 4B
      if(direct_frames_table[direct_id][_ETHERTYPE ]>=0)   direct_frames_table[direct_id][_ETHERTYPE ]==L2.type_len;                            
      if(direct_frames_table[direct_id][_PROTOCOL  ]>=0)   direct_frames_table[direct_id][_PROTOCOL  ]== L2.L3.protocol;                   
    }//direct_eth_item_co 


endclass : l3l4cs_random_testing_eth_item

 
class l3l4cs_random_testing_config extends l3l4cs_test_config;
  `uvm_object_utils(l3l4cs_random_testing_config)

    // constraint items_num_co{
    //   m_axi_wrap_config[AXI_IN ].m_eth_agent_config.items_num==rnd_items_num;
    //   m_axi_wrap_config[AXI_IN ].items_num==rnd_items_num;
    //   m_cs_agent_config.items_num==rnd_items_num;
    //   }

   function new(string name = "");  
      super.new(name);
   endfunction : new
    
endclass: l3l4cs_random_testing_config

class l3l4cs_random_testing extends l3l4cs_test;
  `uvm_component_utils(l3l4cs_random_testing)
  extern         function       new(string name, uvm_component parent);
  extern virtual function void  set_config();
  extern virtual function void  set_sequences();
endclass : l3l4cs_random_testing

function l3l4cs_random_testing::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new
  
function void l3l4cs_random_testing::set_config();
  super.set_config();
  l3l4cs_config ::type_id::set_type_override(l3l4cs_random_testing_config::get_type());    
endfunction : set_config

function void l3l4cs_random_testing::set_sequences();   
  super.set_sequences();
  eth_p_agent_item::type_id::set_type_override(l3l4cs_random_testing_eth_item::get_type());
  eth_p_agent_driver::type_id::set_type_override(eth_cs_agent_driver::get_type());
endfunction : set_sequences



