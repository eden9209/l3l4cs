`ifndef L3L4CS_PKG_SV
    `define L3L4CS_PKG_SV
    ////////////////////////////////////////////////////
    package l3l4cs_pkg;

      `include "uvm_macros.svh"
      import uvm_pkg::*;
      import gk_base_types_pkg::*;
      import gk_base_pkg::*;
      import ce_base_pkg::*;
      import l3l4cs_global_pkg::*;
      import l3l4cs_cs_agent_pkg::*;
 	    import l3l4cs_cs_agent_types_pkg::*;
    	import l3l4cs_axis_wrap_types_pkg::*;
      import axis_vwrp_pkg::*;
      import eth_vip_pkg::*;
      import eth_vip_types_pkg::*;

      import axis_vip_pkg::*;
      import l3l4cs_axis_wrap_pkg::*;
      import gk_axi_vip_pkg::*;
      import eth_p_agent_pkg::*;

      
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
          _IHL         ,// 10
          TABLE_COL_SNTL // 11
      } table_col_t;  



      int direct_frames_table[12][12] ='{
        //        | 0  | 1         | 2      | 3        | 4        | 5        | 6          |  7         | 8   | 9     |  10 |   11       // status       |
        //idx     |vlan|Eth.type   |	    |L2 payload|L3 payload|L4 payload|L5 payload  |Passthrough | chop|options| padd|    IHL|         //              |
        /* 00 */ '{  1 , ETH_IPV4  ,ETH_UDP ,      -1  ,      -1  ,       80 ,     -1   ,         0  ,  -1 ,    -1 ,   -1 ,    -1    },// PASS         |
        /* 01 */ '{  1 , ETH_IPV4  ,ETH_UDP ,      -1  ,      -1  ,      -1 ,      -1   ,         0  ,  -1 ,    -1 ,   -1 ,    -1    },// PASS         |
        /* 02 */ '{  1 , ETH_IPV4  ,ETH_UDP ,      -1  ,      -1  ,      1400  ,   -1   ,         0  ,  -1 ,    -1 ,   -1 ,    -1    },// PASS         |
        /* 03 */ '{  0 , ETH_IPV4  ,ETH_UDP ,      -1  ,      -1  ,       80 ,     -1   ,         0  ,  -1 ,    -1 ,   -1 ,    -1    },// PASS         |
        /* 04 */ '{  0 , ETH_IPV4  ,ETH_UDP ,      -1  ,      -1  ,      -1 ,      -1   ,         0  ,  -1 ,    -1 ,   -1 ,    -1    },// PASS         |
        /* 05 */ '{  0 , ETH_IPV4  ,ETH_UDP ,      -1  ,      -1  ,      1400 ,    -1   ,         0  ,  -1 ,    -1 ,   -1 ,    -1    },// PASS         |
        /* 06 */ '{  1  ,ETH_ARP  ,ETH_UDP ,      -1  ,       -1  ,       -1 ,      -1   ,        0  ,  -1 ,    -1 ,   -1 ,    -1    },// PASS         |
        /* 07 */ '{  0 , ETH_IPV4   ,ETH_PUP ,     -1  ,      -1  ,      1000 ,    -1   ,         0  ,  -1 ,    -1 ,   -1 ,    -1    },// PASS         |
        /* 08 */ '{  1 , ETH_IPV4  ,ETH_UDP ,      -1  ,      -1  ,        0 ,     -1   ,         0  ,  46 ,    -1 ,   -1 ,    -1    },// PASS         |
        /* 09 */ '{  1 , ETH_IPV4  ,ETH_UDP ,      -1  ,      -1  ,        0 ,     -1   ,         0  ,  56 ,    -1 ,   -1 ,    -1    },// PASS         |
        /* 10 */ '{  1 , ETH_IPV4  ,ETH_UDP ,      -1  ,      -1  ,       -1 ,     -1   ,         0  ,  -1 ,    -1 ,   -1 ,     3    }, // PASS        |
        /* 11 */ '{  1 , ETH_IPV6  ,ETH_TCP ,      -1  ,      -1  ,       -1 ,     -1   ,         0  ,  -1 ,    -1 ,   -1,     -1    } // FAIL         |
 
    };


     /*00-MIN frame size with VLAN IPV4-UDP
       01-MID frame size with VLAN IPV4-UDP
       02-MAX frame size with VLAN IPV4-UDP
       03-MIN frame size with NO VLAN IPV4-UDP
       04-MID frame size with NO VLAN IPV4-UDP
       05-MAX frame size with NO VLAN IPV4-UDP
       06-NON IPV4
       07-NON TCP/UDP
       08-Tlast == '1' At the end of Source IPv4
       09-"Tlast == '1' At the end of UDP Length"
       10-IHL<4 for total len err
       11-Max Frame Size and VLAN to IPv6 to TCP


       */

        `include "l3l4cs_types.sv"
        `include "l3l4cs_vif.sv"
        `include "l3l4cs_table.sv"
        `include "l3l4cs_config.sv" 
        `include "l3l4cs_seq_lib.sv"
        `include "l3l4cs_env.sv"
        `include "l3l4cs_test.sv"

          
    endpackage : l3l4cs_pkg
    ////////////////////////////////////////////////////
`endif // L3L4CS_PKG_SV  
