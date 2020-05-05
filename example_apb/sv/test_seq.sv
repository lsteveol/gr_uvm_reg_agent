class test_rseq extends gr_reg_base_seq;

  `uvm_object_utils(test_rseq)

  // new - constructor
  function new(string name="test_rseq");
    super.new(name);
  endfunction
  
  virtual task body();
    `uvm_info(get_type_name(), $psprintf("%s Executing ", get_sequence_path()), UVM_MEDIUM);
    super.body();
    `uvm_info(get_type_name(), $psprintf("%s Done executing ", get_sequence_path()), UVM_MEDIUM);
  endtask // body
  
  task try_it_out;
    get_reg("MY_REG_REG1");
    set_bf("BF1"        , 0); 
    set_reg();
    
    
    get_reg("MY_REG_REG1");
    set_bf("BF1"        , 1); 
    set_reg();
    
    get_reg("MY_REG_REG2");
    set_bf("BF5"        , 6); 
    set_reg();
    
    
    get_reg("MY_REG_REG2");
    set_bf("BF5"        , 3); 
    set_reg();

  endtask
  
endclass



class test_vseq extends gr_reg_base_seq;
  
  test_rseq rseq;


  `uvm_object_utils(test_vseq)
  
   
  // new - constructor
  function new(string name="test_vseq");
     super.new(name);
  endfunction

  virtual task body();
    super.body();
    `uvm_info(get_type_name(), $psprintf("Starting test_vseq"), UVM_MEDIUM);
    
    rseq = test_rseq::type_id::create("rseq");
    rseq.try_it_out();
    
  endtask

endclass
