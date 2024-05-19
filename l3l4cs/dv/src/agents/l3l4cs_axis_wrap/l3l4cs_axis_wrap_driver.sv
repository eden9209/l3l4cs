    class axis_wrap_driver#(
        type ITM = axis_wrap_item,
        type CFG = axis_wrap_config 
    )  extends axis_vwrp_driver #(ITM,CFG);

        `uvm_component_param_utils(axis_wrap_driver #(ITM,CFG))
       
       function new(string name, uvm_component parent);
            super.new(name,parent);
        endfunction: new

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
        endfunction : build_phase

        
    endclass : axis_wrap_driver 



    class eth_cs_agent_driver#(
        type ITM = eth_p_agent_item,
        type CFG = eth_p_agent_config) 
        extends eth_p_agent_driver #(ITM,CFG);
        bit [15:0] cs ;
        int item_id=0;


        `uvm_component_param_utils(eth_cs_agent_driver #(ITM,CFG))

        cs_agent_item cs_item;
        uvm_analysis_port#(cs_agent_item) analysis_port_cs;


        function new(string name, uvm_component parent);
            super.new(name,parent);
            cs_item=cs_agent_item::type_id::create("cs_item",this);
            analysis_port_cs=new("analysis_port_cs",this);
        endfunction

          
        virtual task do_drv();

        super.do_drv();

        cs_item=new();
                
        cs_item.item_id=item_id;
        cs_item.l3_checksum_o=2'b11;
        cs_item.l4_checksum_o=2'b11;
        cs_item.checksum_valid_o=1'b0;

 
         if ((req.L2.type_len != ETH_IPV4 ))
        begin
                cs_item.l3_checksum_o = 2'b00;
                cs_item.checksum_valid_o = 1'b1;
                cs_item.l4_checksum_o = 2'b00;
        end


        else if ((req.L2.L3.protocol != ETH_UDP )) //non tco/udp 
        begin

                cs_item.l4_checksum_o=2'b00;
                cs_item.checksum_valid_o=1'b1;
                cs_item.l3_checksum_o = (1 == req.L2.L3.F.field_ilegal[L3V4_HEADER_CHECKSUM]) ?2'b10 : 2'b01;

        end

        //TLAST BEFORE PROTOCOL 
        else if (req.L2.L3.L4.F.field[L4_PAYLOAD].size == 0) 
        begin

                 cs_item.l3_checksum_o =2'b10;
                cs_item.l4_checksum_o=2'b00; //NON-TCP/UDP
                cs_item.checksum_valid_o=1'b1;

        end

        

        else if(req.L2.L3.F.field[L3V4_IHL][0][3:0] <5 || get_Q_int_value(req.L2.L3.F.field[L3V4_TOTAL_LENGTH]) < 20 )
        begin

                cs_item.checksum_valid_o=1'b1;
                cs_item.l3_checksum_o = (1 == req.L2.L3.F.field_ilegal[L3V4_HEADER_CHECKSUM]) ?2'b10 : 2'b01;
                cs_item.l4_checksum_o = (1 == req.L2.L3.L4.F.field_ilegal[L4_CHECKSUM]) ? 2'b10 : 2'b01;
                cs_item.length_error_o=1'b1;


        end



        else 
        begin


                cs_item.checksum_valid_o=1'b1;
                cs_item.l3_checksum_o = (1 == req.L2.L3.F.field_ilegal[L3V4_HEADER_CHECKSUM]) ?2'b10 : 2'b01;
                cs_item.l4_checksum_o = (1 == req.L2.L3.L4.F.field_ilegal[L4_CHECKSUM]) ? 2'b10 : 2'b01;
                cs_item.length_error_o = 0;


        end

       analysis_port_cs.write(cs_item);
        item_id++;

      endtask: do_drv

    endclass: eth_cs_agent_driver


