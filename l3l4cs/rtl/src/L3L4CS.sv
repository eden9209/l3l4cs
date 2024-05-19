`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: GuardKnox 
// Engineer: Dov Moses
// 
// Create Date: 10/13/2021 11:41:50 AM
// Design Name: Comm Engine
// Module Name: L3L4CS
// Project Name: Comm Engine
// Target Devices: xa7s75fgga484-1Q
// Tool Versions: Vivado v2021.1 (64-bit)
// Description: The block validates the L3 (Network) and L4 (Transport) checksum 
//              of incoming TCP and UDP packets over IPv4 and IPv6. 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module L3L4CS import l4_marker_pkg::*;

(
    input                      sys_clk_i,
    input                      srst_i,
    input                      arst_n_i,
    
    axi_stream_if.slave_ports  as,                 // AXIS - Slave  
    axi_stream_if.master_ports am,                 // AXIS - Master    
    input    markers_t         markers_i,                    
    output   logic             checksum_valid_o,   // CHECKSUM  OUTPUT   
    output   logic      [1:0]  l3_checksum_o,
    output   logic      [1:0]  l4_checksum_o,
    output   logic             l2_error_o,
    output   logic             length_error_o
);

parameter LATENCY        = 3;
parameter TCP            = 6;

enum logic [1:0]
      {st_idle,
      st_l3_ipv4,
      st_l3_ipv6,
      st_l4} 
l3l4_sm;
    
enum logic [0:0]
      {st_wait_trig,         
      st_set_valid}     
l3l4_carry_sm;


logic    [19:0]              l3_checksum_accum;
logic    [19:0]              l4_checksum_accum;   
logic    [19:0]              l3_checksum_carry_accum;
logic    [19:0]              l4_checksum_carry_accum;
logic                        udp_checksum_exist;
logic    [1:0]               udp_checksum_count;
logic                        padding_flag;
logic                        ethertype_marker_s;
logic    [3:0]               ip_header_length;
logic                        ipv6_flag;
logic                        ipv4_flag;
logic                        l4_flag;
logic                        set_output;
logic                        ipv6_flag_carry;
logic                        ipv4_flag_carry;
logic                        l4_flag_carry;
logic                        udp_checksum_opt_carry;
logic    [LATENCY-1:0]       tvalid_sr;
logic    [LATENCY-1:0]       tlast_sr;
logic    [LATENCY-1:0]       tuser_sr;
logic    [7:0]               tdata_sr[LATENCY-1:0];
logic                        tuser_flag;
logic                        tuser_flag_carry;
logic                        length_err_flag;
logic                        length_err_flag_carry;
logic                        l4_hdr_payload;
logic                        l4_hdr_payload_s;
logic   [15:0]               length_for_tcp_pseudo; 

   
//  reset for axis bus delay process   
task reset_pipe; 
    begin      
        tvalid_sr <= '0;  
        tlast_sr <= '0; 
        tuser_sr <= '0; 
        for (int i=0; i<LATENCY; i=i+1) begin        
            tdata_sr[i] <= '0;
        end                            
    end    
endtask 

assign am.tvalid = tvalid_sr[LATENCY-1]; 
assign am.tlast = tlast_sr[LATENCY-1];     
assign am.tdata = tdata_sr[LATENCY-1];
assign am.tuser = tuser_sr[LATENCY-1];
assign l4_hdr_payload = markers_i.layer4_marker| markers_i.l4_payload_marker;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                   This process delays the axi bus by number of clocks defined by the 'LATENCY' parameter
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
always @(posedge sys_clk_i, negedge arst_n_i) begin       
    if (!arst_n_i) begin                                                                               // Asynchronous reset             
        reset_pipe;  
    end 
    else begin                                                                                         // posedge sys_clk_i      
        if (srst_i) begin                                                                           // Synchronous reset        
            reset_pipe;  
        end 
        else begin                                                                                     // clocked process
            tvalid_sr <= {tvalid_sr[LATENCY-2:0],as.tvalid};                                 // master axis is a parameter defined delay of salve  
            tlast_sr <= {tlast_sr[LATENCY-2:0],as.tlast};
            tuser_sr <= {tuser_sr[LATENCY-2:0],as.tuser};
            for (int i=1; i<LATENCY; i=i+1) begin
                tdata_sr[i] <= tdata_sr[i-1];            
            end
            tdata_sr[0] <= as.tdata;
        end
    end
end    

// Reset for  incoming octet process
task reset_main; 
    begin      
        l3l4_sm <= st_idle;
        l3_checksum_accum <= '0;
        l4_checksum_accum <= '0;
        udp_checksum_exist <= '0;
        udp_checksum_count <= '0;
        padding_flag <= '0; 
        ethertype_marker_s <= '0;
        ip_header_length <= '0; 
        ipv6_flag <= '0; 
        set_output <= '0;  
        ipv4_flag <= '0; 
        l4_flag <= '0;  
        tuser_flag <= '0; 
        length_err_flag <= '0;
        l4_hdr_payload_s <= 1'b0;
        length_for_tcp_pseudo <= '0;
    end    
endtask 

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                   This process handles the 2-octet 1's complement summation of the incoming frame.
//                   When tlast is sampled it returns to idle state to wait for the next frame and triggers  
//                   the next process that completes the checksum calculation and sets the output flags. 
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

always @(posedge sys_clk_i, negedge arst_n_i) begin       
    if (!arst_n_i) begin                                                                              // Asynchronous reset             
        reset_main;  
    end 
    else begin                                                                                        // posedge sys_clk_i      
        if (srst_i) begin                                                                          // Synchronous reset        
            reset_main;  
        end 
        else begin                                                                                    // clocked process
            if (as.tvalid == 1) begin
                ethertype_marker_s <= markers_i.ethertype_marker;  
                l4_hdr_payload_s <= l4_hdr_payload;
                case (l3l4_sm)
                    st_idle: begin      
                        ipv6_flag <= '0;                                                               //  reset all accumulators and flags for tvalid active                
                        ipv4_flag <= '0;  
                        l4_flag <= '0;  
                        l3_checksum_accum <= '0;
                        l4_checksum_accum <= '0; 
                        udp_checksum_exist <= '0;  
                        udp_checksum_count <= '0;   
                        tuser_flag <= '0; 
                        length_err_flag <= '0; 
                        length_for_tcp_pseudo <= '0;
                        if (as.tlast == 1) begin
                            tuser_flag <= as.tuser;
                            set_output <= 1'b1;          
                        end                    
                        else begin 
                            set_output <= 1'b0;                                                        // reset trigger for case of tvalid active 
                            if ((ethertype_marker_s == 1) && (markers_i.ethertype_marker == 0) && (markers_i.ipv4_marker == 1)) begin
                                l3l4_sm <= st_l3_ipv4;                                                 // IPv4 packet
                                ip_header_length <= as.tdata[3:0];
                                if (as.tdata[3:0] < 5) begin
                                    length_err_flag <= '1;                                             // IHL < 5 is an error
                                end
                            end   
                            if ((ethertype_marker_s == 1) && (markers_i.ethertype_marker == 0) && (markers_i.ipv6_marker == 1)) begin
                                l3l4_sm <= st_l3_ipv6;                                                 // IPv6 packet
                            end 
                        end
                    end
         
                    st_l3_ipv4: begin                        
                        ipv4_flag <= 1'b1;                                                             // set ipv4 flag for optional L4 checksum
                        if (as.tlast == 1) begin
                            tuser_flag <= as.tuser;
                            l3l4_sm <= st_idle;                                                        // go to idle state
                            set_output <= 1'b1;   
                            padding_flag <= 1'b0;         
                        end       
                        else begin                                             
                            if ((markers_i.udp_source_port_marker == 0) && (markers_i.tcp_marker == 0) && (markers_i.passthrough_marker == 0)) begin
                                padding_flag <= !padding_flag;                                         // toggle padding flag
                                if (padding_flag == 0) begin                                           // accumulate L3 header 16 bit each time  
                                    l3_checksum_accum <= l3_checksum_accum + {tdata_sr[0],as.tdata};                                 
                                end
                            end                                         
                            else begin 
                                if ((markers_i.udp_source_port_marker == 1) || (markers_i.tcp_marker == 1)) begin      // add carry to accumulator before moving to next state
                                    l4_checksum_accum <= {16'd0,l4_checksum_accum[19:16]} + {4'd0,l4_checksum_accum[15:0]};
                                    padding_flag <= 1'b0;                                 
                                    l3l4_sm <= st_l4;                                                  // go to udp over ipv4 state
                                end                                                    
                            end    
                        end                            
                        if (markers_i.total_length_ipv4_marker == 1) begin
                            if (padding_flag == 0) begin                                               // subtract ipv4 header length from total
                                length_for_tcp_pseudo <= {tdata_sr[0],as.tdata}-{ip_header_length,2'b0};  // save length in case needed for tcp pseudo 
                                if (({tdata_sr[0],as.tdata}) < ({ip_header_length,2'b0})) begin   
                                    length_err_flag <= '1;                                             // total length < IP header length is an error                                                                  
                                end    
                            end                                 
                        end     
                        if (markers_i.protocol_ipv4_marker == 1) begin                                 
                            if (as.tdata == TCP) begin                                                   // tcp protocol
                                l4_checksum_accum <= {8'd0,as.tdata} + length_for_tcp_pseudo;            // used saved length for tcp pseudo   
                            end else begin 
                                l4_checksum_accum <= {8'd0,as.tdata};                                    // protocol with upper bit zero insertion  
                            end                                  
                        end                                
                        if (markers_i.source_ipv4_marker == 1) begin
                           if (padding_flag == 0) begin  
                               l4_checksum_accum <= l4_checksum_accum + {tdata_sr[0],as.tdata};
                           end    
                        end        
                        if (markers_i.destination_ipv4_marker == 1) begin 
                            if (padding_flag == 0) begin
                                l4_checksum_accum <= l4_checksum_accum + {tdata_sr[0],as.tdata};
                            end                                                                                                                                    
                        end
                    end    
                    
                    st_l3_ipv6:  begin                                                  
                        ipv6_flag <= 1'b1;                                                             // set ipv6 flag for L3 checksum correct
                        if (as.tlast == 1) begin
                            tuser_flag <= as.tuser;
                            l3l4_sm <= st_idle;                                                        // go to idle state
                            set_output <= 1'b1;   
                            padding_flag <= 1'b0;         
                        end           
                        else begin 
                            if ((markers_i.udp_source_port_marker == 1) || (markers_i.tcp_marker == 1)) begin      // add carry to accumulator before moving to next state
                                l4_checksum_accum <= {16'd0,l4_checksum_accum[19:16]} + {4'd0,l4_checksum_accum[15:0]}; 
                                padding_flag <= 1'b0;                                 
                                l3l4_sm <= st_l4;                                                      // go to udp over l4 state
                            end 
                            else begin
                                padding_flag <= !padding_flag;                                         // toggle padding flag    
                            end                                                    
                        end    
                        if (markers_i.total_length_ipv6_marker == 1) begin                             // accumulate L4 pseudo header
                            if (padding_flag == 0) begin                                
                                length_for_tcp_pseudo <= {tdata_sr[0],as.tdata};
                            end           
                        end     
                        if (markers_i.next_header_marker == 1) begin                                   // next header with upper bit zero insertion
                            if (as.tdata == TCP) begin                                                   // tcp protocol
                                l4_checksum_accum <= {8'd0,as.tdata} + length_for_tcp_pseudo;            // used saved length for tcp pseudo   
                            end else begin 
                                l4_checksum_accum <= {8'd0,as.tdata};                                    // protocol with upper bit zero insertion  
                            end                                  
                        end     
                        if (markers_i.source_ipv6_marker == 1) begin 
                            if (padding_flag == 0) begin  
                                l4_checksum_accum <= l4_checksum_accum + {tdata_sr[0],as.tdata};
                            end 
                        end        
                        if (markers_i.destination_ipv6_marker == 1) begin 
                            if (padding_flag == 0) begin  
                                l4_checksum_accum <= l4_checksum_accum + {tdata_sr[0],as.tdata};
                            end 
                        end                                                                                                                                                               
                    end    

                    st_l4: begin
                        l4_flag <= 1'b1;                        
                        l3_checksum_accum <= {16'd0,l3_checksum_accum[19:16]} + {4'd0,l3_checksum_accum[15:0]};// add L3 carry of accumulation                                                                                         
                        if (markers_i.udp_checksum_marker == 1) begin 
                            udp_checksum_count <= udp_checksum_count + 1;
                            if (as.tdata != 0) begin                             
                                udp_checksum_exist <= 1'b1;                                            // verify checksum bytes zero value
                            end
                        end     
                        if (as.tlast == 1) begin                                                       // end of packet
                            tuser_flag <= as.tuser;
                            l3l4_sm <= st_idle;  
                            set_output <= 1'b1;            
                            padding_flag <= 1'b0;  
                            if (l4_hdr_payload == 1) begin                                             // frame ended with no L2 padding (>= 64 byte)
                                if (padding_flag == 0) begin                                           // last byte no 2-octet padding  
                                    l4_checksum_accum <= l4_checksum_accum + {tdata_sr[0],as.tdata};
                                end    
                                else begin                                                             // last byte with 2-octet padding
                                    l4_checksum_accum <= l4_checksum_accum + {4'd0,as.tdata,8'd0};
                                end    
                            end else if (l4_hdr_payload_s == 1) begin                                  // start of L2 padding (< 64 bytes)
                                if (padding_flag == 0) begin                                           // odd number of octets in L4 so do 2-octet pad (ignore last invert of padding flag)
                                    l4_checksum_accum <= l4_checksum_accum + {4'd0,tdata_sr[0],8'd0};
                                end    
                            end    
                        end    
                        else begin
                            if (l4_hdr_payload == 1) begin                                             // accumulate L4 2-octet pairs 
                                padding_flag <= !padding_flag;                                        
                                if (padding_flag == 0) begin  
                                    if (markers_i.udp_total_length_marker == 1) begin                 // 2x total length for udp pseudo hdr                                                                              
                                        l4_checksum_accum <= l4_checksum_accum + {tdata_sr[0],as.tdata,1'b0};                                         
                                    end else begin 
                                        l4_checksum_accum <= l4_checksum_accum + {tdata_sr[0],as.tdata}; 
                                    end    
                                end 
                                else begin                                                             // add carry to accumulator every accumulation
                                    l4_checksum_accum <= {16'd0,l4_checksum_accum[19:16]} + {4'd0,l4_checksum_accum[15:0]};                                    
                                end
                            end else if (l4_hdr_payload_s == 1) begin                                  // start of L2 padding (< 64 bytes)
                                if (padding_flag == 0) begin                                           // odd number of octets in L4 so do 2-octet pad (ignore last invert of padding flag)
                                    l4_checksum_accum <= l4_checksum_accum + {4'd0,tdata_sr[0],8'd0};
                                end    
                            end    
                        end                                                   
                    end 

                    default: begin                                                                                                                               
                        l3l4_sm <= st_idle;  
                        padding_flag <= 1'b0;
                    end
                endcase
            end  
            else begin                                                                                 // reset trigger for case of tvalid not active         
                set_output <= 1'b0; 
            end  
        end
    end  
end          

// Reset for the output setting process
task reset_main_carry; 
    begin    
        checksum_valid_o <= '0;
        l3_checksum_o <= '1;
        l4_checksum_o <= '1;    
        l3l4_carry_sm <= st_wait_trig;
        l3_checksum_carry_accum <= '0;
        l4_checksum_carry_accum <= '0;
        ipv6_flag_carry <= '0;
        ipv4_flag_carry <= '0;
        l4_flag_carry <= '0;    
        udp_checksum_opt_carry <= '0;     
        tuser_flag_carry <= '0; 
        length_err_flag_carry <= '0; 
        l2_error_o <= 1'b0;
        length_error_o <= 1'b0;         

    end    
endtask 

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//         This process completes the checksum calculation and sets the output flags. 
//         It is triggered by the previous process
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

always @(posedge sys_clk_i, negedge arst_n_i) begin       
    if (!arst_n_i) begin                                                                               // Asynchronous reset             
        reset_main_carry;  
    end 
    else begin                                                                                         // posedge sys_clk_i      
        if (srst_i) begin                                                                           // Synchronous reset        
            reset_main_carry;  
        end 
        else begin
            case (l3l4_carry_sm) 
                st_wait_trig: begin
                    checksum_valid_o <= 1'b0;   
                    l3_checksum_o <= '1;
                    l4_checksum_o <= '1;                              
                    if (set_output == 1) begin                                                         // add carry of accumulation
                        l3_checksum_carry_accum <= {16'd0,l3_checksum_accum[19:16]} + {4'd0,l3_checksum_accum[15:0]};
                        l4_checksum_carry_accum <= {16'd0,l4_checksum_accum[19:16]} + {4'd0,l4_checksum_accum[15:0]};    
                        l3l4_carry_sm <= st_set_valid; 
                        if (ipv6_flag == 1) begin                        
                            ipv6_flag_carry <= 1'b1;
                        end    
                        else begin
                            ipv6_flag_carry <= 1'b0;
                        end
                        if (ipv4_flag == 1) begin
                            ipv4_flag_carry <= 1'b1;
                        end
                        else begin
                            ipv4_flag_carry <= 1'b0;
                        end                            
                        if (l4_flag == 1) begin
                            l4_flag_carry <= 1'b1;
                        end  
                        else begin
                            l4_flag_carry <= 1'b0;
                        end                           
                        if ((udp_checksum_exist == 0) && (udp_checksum_count == 2) && (ipv4_flag == 1))begin  
                            udp_checksum_opt_carry <= 1'b1;                                           // cs optional if both bytes = 0 and not ipv6 
                        end
                        else begin
                            udp_checksum_opt_carry <= 1'b0;
                        end   
                        if (tuser_flag == 1) begin
                            tuser_flag_carry <= 1'b1;    
                        end
                        else begin
                            tuser_flag_carry <= 1'b0;
                        end  
                        if (length_err_flag == 1) begin
                            length_err_flag_carry <= 1'b1;
                        end 
                        else begin
                            length_err_flag_carry <= 1'b0;
                        end
                    end
                end

                st_set_valid: begin
                    checksum_valid_o <= 1'b1; 
                    l3l4_carry_sm <= st_wait_trig;
                    if (tuser_flag_carry == 1) begin
                        l2_error_o <= 1'b1;   
                    end 
                    else begin
                        l2_error_o <= 1'b0;                           
                    end

                    if (length_err_flag_carry == 1) begin
                        length_error_o <= 1'b1;                                                      
                    end    
                    else begin
                        length_error_o <= 1'b0;                        
                    end

                    if (((l4_flag_carry == 1) && (~({12'd0,l4_checksum_carry_accum[19:16]} + l4_checksum_carry_accum[15:0]) == 16'd0)) || (udp_checksum_opt_carry == 1)) begin                        
                        l4_checksum_o <= 2'b01;                                                       // L4 checksum correct or UDP optional CS over IPv4
                    end        
                    else if (l4_flag_carry == 1) begin    
                        l4_checksum_o <= 2'b10;                                                       // L4 with checksum not correct
                    end 
                    else begin 
                        l4_checksum_o <= 2'b00;                                                       // non TCP/UDP packet
                    end     
                    
                    if  (((ipv4_flag_carry == 1) && (~({12'd0,l3_checksum_carry_accum[19:16]} + l3_checksum_carry_accum[15:0]) == 16'd0)) || (ipv6_flag_carry == 1)) begin
                        l3_checksum_o <= 2'b01;                                                      // L3 checksum correct or IPv6                        
                    end  
                    else if (ipv4_flag_carry == 1) begin                                             // IPv4 with checksum not correct
                        l3_checksum_o <= 2'b10;                        
                    end
                    else begin
                        l3_checksum_o <= 2'b00;                                                      // non IP packet
                    end
                end

                default: begin                                                                                                                               
                    l3l4_carry_sm <= st_wait_trig;  
                end                
            endcase 
        end       
    end    
end    
endmodule