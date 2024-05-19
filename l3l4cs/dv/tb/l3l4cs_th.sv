import uvm_pkg::*;

import l3l4cs_pkg::*;
import l3l4cs_cs_agent_pkg::*;
import l3l4cs_axis_wrap_pkg::*;
import axis_vwrp_pkg::*;
import l4_marker_pkg::*;
import ce_base_types_pkg::*;
import eth_vip_types_pkg::*;



module l3l4cs_th(input clk, input reset_n);

  l3l4cs_vif    vif;
  import l3l4cs_axis_wrap_types_pkg::*;

   `include "l3l4cs_th_ifs.sv" 
   initial  begin

      vif = l3l4cs_vif::type_id::create($sformatf("l3l4cs_vif"));
      `include "l3l4cs_th_vif_connect.sv" 
      uvm_config_db #(l3l4cs_vif)::set(null, "*",$sformatf("th_vif"), vif);
      
   end//initial

endmodule
