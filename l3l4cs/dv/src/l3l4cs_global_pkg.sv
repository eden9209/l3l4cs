`ifndef L3L4CS_GLOBAL_SV
    `define L3L4CS_GLOBAL_SV
    /////////////////////////////////////////
    package l3l4cs_global_pkg;
        `include "uvm_macros.svh"
        import uvm_pkg::*;
        import ce_base_global_pkg::*;

        class l3l4cs_global extends ce_base_global;
            `uvm_object_utils(l3l4cs_global)

            bit coverage_en = 1;
            rand bit[`STREAMS_NUM-1:0] stream_enable; //bit per stream
            int active_streams[$]; //stream list
            bit stop_sim_now = 0;
            bit mon_info,drv_info;
            event vseq_body_done_event;

            constraint l3l4cs_ch_en_soft_co {
                soft stream_enable == 1;
            }

            function new(string name = "");
                super.new(name);
                if ($test$plusargs("COVERAGE_EN")) begin
                    coverage_en = 1;
                end
            endfunction: new

            function void post_randomize();
                for (int i=0; i<8; i++) begin
                    if (stream_enable[i] == 1) begin
                        active_streams.push_back(i);
                    end
                end
            endfunction

            task wait4_event(event e,string s);
                @ e;
                `uvm_info(get_name(), {s," event triggered"}, UVM_HIGH)   
            endtask:wait4_event

        endclass : l3l4cs_global
            
   endpackage: l3l4cs_global_pkg
`endif // L3L4CS_GLOBAL_SV

