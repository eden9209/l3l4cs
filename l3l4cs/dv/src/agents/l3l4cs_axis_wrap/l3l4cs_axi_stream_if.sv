
interface axi_stream_if #(parameter DWIDTH=76,UWIDTH=1)
    (   input clk,
        input reset_n
    );

     parameter DATA=76;
     parameter VALID=1;
  
      `include "gk_base_if_common.sv"

    
        logic tvalid;
        logic tlast;
        logic [UWIDTH-1:0] tuser;
        logic tuser_slv;
        logic [DWIDTH-1:0] tdata;
        logic tready;
        

 
     task wait_for_clk();
         @(posedge clk && reset_n===1'b1);
      endtask

        // master module port directions
    modport master_ports (
        output tvalid,
        output tlast,
        output tuser,
        output tdata,
        input  tuser_slv,
        input  tready
    );    
    
    modport slave_ports (
        input  tvalid,
        input  tlast,
        input  tuser,
        input  tdata,
        output tuser_slv,
        output tready
    );

    endinterface : axi_stream_if
    

