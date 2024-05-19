    class axis_wrap_coverage#(type ITM=axis_wrap_item) extends axis_vwrp_coverage#(ITM);
        `uvm_component_param_utils(axis_wrap_coverage)

        extern function new(string name, uvm_component parent);
        extern function void write(input ITM t);

    endclass : axis_wrap_coverage 
  
    function axis_wrap_coverage::new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    function void axis_wrap_coverage::write(input ITM t);
        super.write(t);
    endfunction : write

 