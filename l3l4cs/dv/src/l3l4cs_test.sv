
`ifndef L3L4CS_TEST_SV
`define L3L4CS_TEST_SV

    class l3l4cs_test_config extends l3l4cs_config;
        `uvm_object_utils(l3l4cs_test_config)

        function new(string name = "");  
            super.new(name);
        endfunction : new
    endclass: l3l4cs_test_config

    class l3l4cs_test extends ce_base_test#(l3l4cs_env,l3l4cs_config,l3l4cs_global,l3l4cs_vif);
        `uvm_component_utils(l3l4cs_test)

        function new(string name="", uvm_component parent);
            super.new("l3l4cs", parent);
        endfunction : new

        function void build_phase(uvm_phase phase);
            `uvm_info(get_name(), "In build_phase", UVM_HIGH)
            super.build_phase(phase); 
            print_topology_en=0;
            print_factory_en=0;
        endfunction : build_phase

        function void set_config();
            super.set_config();
         endfunction : set_config

        function void set_sequences();   
            super.set_sequences();
            l3l4cs_default_seq::type_id::set_type_override(l3l4cs_default_seq::get_type());

        endfunction : set_sequences


    endclass : l3l4cs_test
`endif // L3L4CS_TEST_SV

