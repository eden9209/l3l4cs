`ifndef L3L4CS_AXIS_WRAP_DEFINES_SV
`define L3L4CS_AXIS_WRAP_DEFINES_SV

`define AXI_WRP_DATA_WD 8
`define AXI_WRP_ADDR_WD 8
`define AXI_WRP_VLD_WD  1
`define AXI_WRP_WORDS   1
`define AXI_WRP_STREAMS 1


  `define ETH_UDP_Q '{'h11}
  `define ETH_TCP_Q '{'h06}
 // `define ETH_TCP_Q  6
  `define NO_TCP_UDP '{'h03}
  `define GOOD_IHL '{'h45}
  `define IHL_LESS_5 '{'h43}
  `define TOTAL_LEN_LESS_20 '{'h00,'h13}
  `define TOTAL_LEN_BETWEEN_20_TO_1500 '{'h01,'hF4}
  `define TOTAL_LEN_MIN_20 '{'h00,'h14}
  `define TOTAL_LEN_MAX_1500 '{'h05,'hDC}



`endif//L3L4CS_AXIS_WRAP_DEFINES_SV  



