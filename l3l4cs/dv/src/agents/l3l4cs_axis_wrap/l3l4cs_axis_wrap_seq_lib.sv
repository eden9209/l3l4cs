
`ifndef AXI_WRAP_SEQ_LIB_SV
    `define AXI_WRAP_SEQ_LIB_SV
    class axis_wrap_data_seq extends axis_vwrp_data_seq#(axis_wrap_config,axis_wrap_item);
        `uvm_object_utils(axis_wrap_data_seq)
        extern function new(string name = "");
        extern virtual task body();
       extern virtual task          post_body();
    //    extern virtual function bit  last_word_cond(int curr_word,int last);
    endclass : axis_wrap_data_seq
    
    function axis_wrap_data_seq::new(string name = "");
        super.new(name);
    endfunction : new
    task axis_wrap_data_seq::body();
        super.body();
    endtask :body 

  
    task axis_wrap_data_seq::post_body();
        super.post_body();
        //m_config.wait_Xclk(10);
        //m_config.m_global.set_stop_sim_now(1);
    endtask: post_body
    // endtask :post_body 
    // //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    // function bit axis_wrap_data_seq::last_word_cond(int curr_word,int last);
    //     bit result;
    //     result=(curr_word>=last-8);
    //     return(result);
    // endfunction:last_word_cond





`endif// AXI_WRAP_SEQ_LIB_SV
