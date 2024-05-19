// -------------------------------------------------------------------------
// File name		: l3l4cs_cs_agent_item.sv 
// Title				: 
// Project      	: 
// Developers   	: eden 
// Created      	: Fri July 13, 2023  08:24AM 
// Last modified  : 
// Description  	: 
// Notes        	: 
// Version			: 0.1
// ---------------------------------------------------------------------------
// Copyright 2023 (c) GuardKnox Ltd
// Confidential Proprietary 
// ---------------------------------------------------------------------------
`ifndef CS_AGENT_TRANS_SV
    `define CS_AGENT_TRANS_SV
    class cs_agent_item extends ce_base_item; 
        `uvm_object_utils(cs_agent_item)

      bit checksum_valid_o;   
      bit  [1:0] l3_checksum_o;   
      bit  [1:0] l4_checksum_o;   
      bit  l2_error_o;   
      bit  length_error_o; 
      rand bit valid;  
      int item_id;
      int cnt;


      function new(string name = "");
         super.new(name);
     endfunction : new  

     function string get_string(int padd=0);
      string str=get_hdr_string();
        return str;
  endfunction : get_string
  
  function string get_hdr_string();
      string str;
      string stream_s;
      str={
        $sformatf("item_id         [%1d] %t\n",item_id,timestamp),
        $sformatf("checksum_valid_o[%b]\n",checksum_valid_o),
        $sformatf("l3_checksum_o   [%b]\n",l3_checksum_o),
        $sformatf("l4_checksum_o   [%b]\n",l4_checksum_o),
        $sformatf("l2_error_o      [%b]\n",l2_error_o),
        $sformatf("length_error_o  [%b]\n",length_error_o)
      };
      return str;
  endfunction : get_hdr_string


    function void cast2cs_item(ref cs_agent_item ref_item,uvm_object rhs);
        if (!$cast(ref_item, rhs)) 
        `uvm_fatal(get_name(), "Cast of rhs object failed")
    endfunction: cast2cs_item


  function bit do_compare(uvm_object rhs, uvm_comparer comparer);
    bit result;
    cs_agent_item ref_item;
    cast2cs_item(ref_item, rhs);
    result = super.do_compare(rhs, comparer);
    result &= comparer.compare_field($sformatf("checksum_valid_o"),checksum_valid_o ,  ref_item.checksum_valid_o, 1);
    result &= comparer.compare_field($sformatf("l3_checksum_o"),l3_checksum_o ,  ref_item.l3_checksum_o, 2);
    result &= comparer.compare_field($sformatf("l4_checksum_o"),l4_checksum_o ,  ref_item.l4_checksum_o, 2);
    result &= comparer.compare_field($sformatf("l2_error_o"),l2_error_o ,  ref_item.l2_error_o, 1);
    result &= comparer.compare_field($sformatf("length_error_o"),length_error_o ,  ref_item.length_error_o, 1);
    return result;
endfunction : do_compare
  endclass : cs_agent_item 
`endif // CS_AGENT_TRANS_SV
