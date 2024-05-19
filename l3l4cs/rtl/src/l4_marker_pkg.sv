package l4_marker_pkg;

    timeunit 1ns;
    timeprecision 1ps;
    
        typedef enum logic [5:0] { 
            st_idle       = 6'd0,    // State 0, Start state.
            st_destmac    = 6'd1,    // Destination MAC state. 
            st_srcmac     = 6'd2,    // Source MAC state.
            st_arbt       = 6'd3,    // Arbitration state for choosing the protocol. 
            st_vlan       = 6'd4,    // VLAN state.
            st_ipv4       = 6'd5,    // IPV4 operation state.
            st_ipv6       = 6'd6,    // IPV6 operation state.
            st_arp        = 6'd7,    // ARP state. 
            st_ptp        = 6'd8,    // Point to Point state.
            st_red_tag    = 6'd9,    // Redundency TAG state.
            st_udp        = 6'd10,   // UDP operation state.
            st_tcp        = 6'd11,   // TCP operation state.
            st_l4_payload = 6'd12,   // Layer 4 Payload operation state.
            st_pass_w0    = 6'd13,   // Pass through wait0
            st_pass_w1    = 6'd14,   // Pass through wait1
            st_passthrough= 6'd15,   // Pass through operation state.
            st_end        = 6'd16   // 
        } type_state_e;
    
        localparam logic [15:0] VLAN     = 16'h8100;
        localparam logic [15:0] IPV4     = 16'h0800;
        localparam logic [15:0] IPV6     = 16'h86DD;
        localparam logic [15:0] ARP      = 16'h0806;
        localparam logic [15:0] PTP      = 16'h88F7;
        localparam logic [15:0] RED_TAG  = 16'hF1C1;
    
        localparam logic [7:0] UDP = 8'd17;
        localparam logic [7:0] TCP = 8'd06;
    
        typedef struct {
            logic destination_mac_marker;
            logic source_mac_marker;
            logic vlan_marker;
            logic ethertype_marker;
            logic arp_marker;
            logic ptp_marker;
            logic redundancy_tag_marker;
            logic ipv4_marker;
            logic total_length_ipv4_marker;
            logic protocol_ipv4_marker;
            logic header_checksum_marker;
            logic source_ipv4_marker;
            logic destination_ipv4_marker;
            logic ipv6_marker;
            logic total_length_ipv6_marker;
            logic next_header_marker;
            logic source_ipv6_marker;
            logic destination_ipv6_marker;
            logic udp_source_port_marker;
            logic udp_destination_port_marker;
            logic udp_total_length_marker;
            logic udp_checksum_marker;
            logic l4_payload_marker;
            logic eof_marker;
            logic tcp_marker;
            logic sof_marker;
            logic layer2_marker;
            logic layer3_marker;
            logic layer4_marker;
            logic layer5_marker;
            logic passthrough_marker;
        } markers_t;
    
    endpackage : l4_marker_pkg
    