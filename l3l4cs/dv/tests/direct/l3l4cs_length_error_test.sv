
class l3l4cs_length_error_test_eth_data_seq extends eth_p_agent_data_seq;
    `uvm_object_utils(l3l4cs_length_error_test_eth_data_seq)
    parameter CORNER_CASES=2;
    int direct_id;
  
    function new(string name = "");
      super.new(name);
  endfunction : new
  
  task body();
      super.body();
  endtask :body 
  
  
  function void randomize_item(int item_id);
    direct_id=item_id%CORNER_CASES;
    m_item.L2.L3.L3_total_length_co.constraint_mode(0);
    m_item.L2.L3.L3_protocol_co.constraint_mode(0);
    m_item.L2.L3.L3_ihl_options_size_co.constraint_mode(0);
    m_item.L2.L3.L3_version_co.constraint_mode(0);




   m_item.L2.L3.F.field_ilegal[L3V4_HEADER_CHECKSUM] =frames_length_err [direct_id][6][0]; 
    m_item.L2.L3.L4.F.field_ilegal[L4_CHECKSUM] =  frames_length_err  [direct_id][7][0]; ;
  

  
   if (!m_item.randomize() with{
    L2.F.field[L2_TAG].size()==                     frames_length_err [direct_id][0][0]*4;
    `constraint_q(L2.F.field[L2_TAG      ],frames_length_err [direct_id][1])
    `constraint_q(L2.F.field[L2_TYPE_LEN  ],frames_length_err [direct_id][2]) 
    `constraint_q(L2.L3. F.field[L3V4_PROTOCOL  ],frames_length_err [direct_id][3]) 
    `constraint_q(L2.L3.F. field[L3V4_IHL   ],frames_length_err[direct_id][4])
    `constraint_q(L2.L3.F.field[L3V4_TOTAL_LENGTH ],frames_length_err[direct_id][5])
    L2.L3.L4.L5.pdu_payload_type==pdu_payload_types_t'(TO_PDU);
  
  
    }) begin
      `uvm_error(get_name(), $sformatf("Failed to randomize item object(%0d)",direct_id))           
   end
   
    m_item.pack();
  `uvm_info(get_name(),m_item.get_string(),UVM_HIGH)
  
  endfunction : randomize_item
  
   endclass : l3l4cs_length_error_test_eth_data_seq
  
  
  class l3l4cs_length_error_test_config extends l3l4cs_test_config;
    `uvm_object_utils(l3l4cs_length_error_test_config)
  
    constraint items_num_co{
          m_axi_wrap_config[AXI_IN ].m_eth_agent_config.items_num==2;
      }//items_num_co 
      
     function new(string name = "");  
        super.new(name);
     endfunction : new
  endclass: l3l4cs_length_error_test_config
  
  class l3l4cs_length_error_test extends l3l4cs_test;
    `uvm_component_utils(l3l4cs_length_error_test)
    extern         function       new(string name, uvm_component parent);
    extern virtual function void  set_config();
    extern virtual function void  set_sequences();
  endclass : l3l4cs_length_error_test

  function l3l4cs_length_error_test::new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new
    
  //////////////////////////////////////////////////////////////////////
  function void l3l4cs_length_error_test::set_config();
    super.set_config();
    l3l4cs_config ::type_id::set_type_override(l3l4cs_length_error_test_config::get_type());    
  endfunction : set_config
  //////////////////////////////////////////////////////////////////////
  function void l3l4cs_length_error_test::set_sequences();   
    super.set_sequences();
    eth_p_agent_driver::type_id::set_type_override(eth_cs_agent_driver::get_type());
    eth_p_agent_data_seq::type_id::set_type_override(l3l4cs_length_error_test_eth_data_seq::get_type());
  endfunction : set_sequences
  
  
  
  