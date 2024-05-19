`ifndef L3L4CS_CONFIG_SV
`define L3L4CS_CONFIG_SV


class l3l4cs_config 
    extends ce_base_config#(l3l4cs_vif,l3l4cs_global);
   l3l4cs_global m_global;

    `uvm_object_utils(l3l4cs_config)
    rand bit cs_agent_build_en;
	rand bit[`AXI_WRPS_NUM-1:0]   axi_wrap_build_en;

    rand cs_agent_config         m_cs_agent_config;
	rand axis_wrap_config         m_axi_wrap_config[`AXI_WRPS_NUM];


	 constraint cs_agent_build_en_co{
		cs_agent_build_en==1'b1;
	  }


	 constraint items_num_co{
      m_axi_wrap_config[AXI_IN ].m_eth_agent_config.items_num==100;
      m_axi_wrap_config[AXI_IN ].items_num==100;
      m_cs_agent_config.items_num==100;
      }

  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    constraint agents_mode_co{

		m_cs_agent_config.agent_mode==CKR_EXT;
		m_cs_agent_config.build_en==cs_agent_build_en;
		m_cs_agent_config.stream_en==1;
		m_cs_agent_config.cov_en==1;
   
	   axi_wrap_build_en[AXI_IN]==	1'b1;
	   m_axi_wrap_config[AXI_IN ].agent_mode==DRV_MON_ACT;
	   m_axi_wrap_config[AXI_IN ].m_eth_agent_config.agent_mode== DRV_MON_ACT;

	   m_axi_wrap_config[AXI_IN ].build_en== axi_wrap_build_en[AXI_IN];
	   m_axi_wrap_config[AXI_IN ].m_eth_agent_config.build_en== axi_wrap_build_en[AXI_IN];
   	  m_axi_wrap_config[AXI_IN ].m_eth_agent_config.stream_en==1;
	  m_axi_wrap_config[AXI_IN ].stream_en==1;
	   m_axi_wrap_config[AXI_IN ].m_eth_agent_config.mst_slv_mode==MST;
   	   m_axi_wrap_config[AXI_IN ].m_eth_agent_config.cov_en==1;
	   m_axi_wrap_config[AXI_IN ].cov_en==1;
	   m_axi_wrap_config[AXI_IN].input_rate_ckr[MST]==1;


	   axi_wrap_build_en[AXI_OUT]==	1'b1;
	   m_axi_wrap_config[AXI_OUT ].agent_mode==MON_ACT;
	   m_axi_wrap_config[AXI_OUT ].build_en== axi_wrap_build_en[AXI_OUT];
	   m_axi_wrap_config[AXI_OUT ].m_eth_agent_config.build_en== axi_wrap_build_en[AXI_OUT];
   	   m_axi_wrap_config[AXI_OUT ].m_eth_agent_config.stream_en==1;
	  m_axi_wrap_config[AXI_OUT ].stream_en==1;
	   m_axi_wrap_config[AXI_OUT ].m_eth_agent_config.mst_slv_mode==SLV;
	   m_axi_wrap_config[AXI_OUT ].m_eth_agent_config.cov_en==0;
	   m_axi_wrap_config[AXI_OUT ].cov_en==0;



   }//agents_mode_co


   constraint markers_check_co{
   	m_axi_wrap_config[AXI_IN ].m_eth_agent_config.collect_l4m_markers==1;
   	m_axi_wrap_config[AXI_OUT ].m_eth_agent_config.collect_l4m_markers==0;
     m_axi_wrap_config[AXI_IN ].m_eth_agent_config.mrk_comp_mode==MRK_COMP_INT;//EXT;
     m_axi_wrap_config[AXI_OUT ].m_eth_agent_config.mrk_comp_mode==MRK_COMP_DISABLE;//EXT;

}//markers_check_co


  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    function new(string name = "");
        super.new(name);
        m_global = l3l4cs_global::type_id::create("m_global");
    	m_cs_agent_config = cs_agent_config::type_id::create(cs_agent_name(0));
	   // m_axi_wrap_config = axis_wrap_config::type_id::create(axi_wrap_name(0));

		foreach(m_axi_wrap_config[axi_wrp_i]) begin
            m_axi_wrap_config[axi_wrp_i] = axis_wrap_config::type_id::create(axi_wrp_name(axi_wrp_i));
            m_axi_wrap_config[axi_wrp_i].id = axi_wrp_i;
            m_axi_wrap_config[axi_wrp_i].path_name = axi_wrp_name(axi_wrp_i);
        end

		m_axi_wrap_config[AXI_IN ].path_name = axi_wrp_name(0);


		m_cs_agent_config.path_name=cs_agent_name(0);
		m_global.drv_info=0;


    endfunction: new

	virtual function string axi_wrp_name(int axi_wrp_i, int idx=0);
        string s;
        `enum_cast(axi_wrp_t,child,axi_wrp_i)
        //`enum_cast(l4mrk_testpoint_t,tp,axi_wrp_i)
        case(idx)
            0:s=child.name;
            //	1:s=tp.name;
        endcase//idx
        return(s);
    endfunction : axi_wrp_name


    function void post_randomize();

        super.post_randomize();

		foreach(m_axi_wrap_config[axi_wrp_i]) begin
			m_axi_wrap_config[axi_wrp_i].build_en=axi_wrap_build_en[axi_wrp_i];
		end

		m_axi_wrap_config[AXI_IN].m_eth_agent_config.drv_en[ACT]=1; 
        m_axi_wrap_config[AXI_IN].drv_en[ACT]=1; 
        m_axi_wrap_config[AXI_IN].m_eth_agent_config.drv_en[EXP]=0;
        m_axi_wrap_config[AXI_IN].drv_en[EXP]=0;

    endfunction : post_randomize


    virtual function string cs_agent_name(int cs_agent_i, int idx=0);
       	string s;
	    `enum_cast(cs_agent_t,child,cs_agent_i)
	    case(idx)
		0:s=child.name;
	    endcase//idx
	    return(s);
    endfunction : cs_agent_name

//     virtual function string axi_wrap_name(int axi_wrap_i, int idx=0);
// 	   string s;
// 	  `enum_cast(axis_wrap_t,child,axi_wrap_i)
//   	   case(idx)
// 	   0:s=child.name;
// 		//1:s=tp.name;
// 	   endcase//idx
// 	   return(s);
//    endfunction : axi_wrap_name


//    function string get_table_string(start_t kind,int padd=0, string add="");
// 	 string s;
// 	 string line={{150{"~"}},"\n"};
// 	 int ROW=1,COL=3;
// 	 l3l4cs_table m_table;
// 	//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 
// 	 m_table=l3l4cs_table::type_id::create($sformatf("%0s:","l3l4cs_table"));
// 	//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 
// 	//setting  table parameters    
// 	 m_table.CELL_WD0=14;
// 	 m_table.CELL_WD1=14;
// 	 m_table.init(COL,ROW);
// 	 m_table.side_hdr[0]="domain";
// 	 m_table.right_side_en=0;
// 	 m_table.max_table=1;
// 	 m_table.side_hdr[1]="";
// 	 foreach(m_table.subsys_build_en[i])
// 	 	m_table.subsys_build_en[i]=1;
// 	 //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// 	 m_table.subsys_frefix[0]="ETH";
// 	 m_table.subsys_frefix[1]="AXI";
// 	 //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// 	 m_table.subsys_name[0]="frame";
// 	 m_table.subsys_name[1]="frame";
// 	 m_table.subsys_name[2]="cs";
	 
// 	 //~~~~~~~~left side~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// 	 m_table.agent_name[0][0]="AXI_WRAPPER_IN";
// 	//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// 	 foreach(m_table.agent_id[row])begin
// 		m_table.agent_id[row][0]=row;               
// 	 end//row

// 	//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// 	 m_axi_wrap_config.m_eth_agent_config .fill_table_values(m_table,0,0);
// 	 m_axi_wrap_config.fill_table_values(m_table,1,0);
// 	 m_cs_agent_config.fill_table_values(m_table,2,0);

// 	//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// 	 s={s,m_table.get_table(kind,add),"\n",
// 	 m_table.get_table_info()
// 		};
// 	return (s);

//    endfunction : get_table_string

	task wait_Xclk(int x);
        repeat(x) 
		m_axi_wrap_config[AXI_IN].wait_clk();
    endtask: wait_Xclk

endclass : l3l4cs_config 
`endif // L3L4CS_CONFIG_SV

