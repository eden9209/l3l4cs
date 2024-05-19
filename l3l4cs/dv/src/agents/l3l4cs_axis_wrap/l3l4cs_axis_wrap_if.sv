
`ifndef  AXI_WRAP_IF_SV
    `define  AXI_WRAP_IF_SV
    interface  axis_wrap_if(input clk,input reset_n); 
        parameter WORDS=`AXI_WRP_WORDS;
        parameter DATA =`AXI_WRP_DATA_WD;
        parameter ADDR =`AXI_WRP_ADDR_WD;
        parameter VALID=`AXI_WRP_VLD_WD;
        parameter MRK_WD=31;//ETH_MRK_SNTL;
    
        `include "axis_vwrp_if_common.sv"

        // task wait_for_clk();
        //     @(posedge clk && reset_n===1'b1);
        //  endtask
          
    endinterface :  axis_wrap_if
`endif //  AXI_WRAP_IF_SV
