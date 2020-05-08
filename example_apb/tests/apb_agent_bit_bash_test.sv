class apb_agent_bit_bash_test extends apb_agent_base_test;
  
  `uvm_component_utils(apb_agent_bit_bash_test)
  
  function new(string name = "apb_agent_bit_bash_test", uvm_component parent=null);
    super.new(name,parent);
  endfunction 
  
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction
  
  
  task run_phase(uvm_phase phase);
    phase.raise_objection(this, "test");
    
    super.run_phase(phase);
    
    begin
      gr_reg_bit_bash_seq    seq;
      
      seq         = gr_reg_bit_bash_seq::type_id::create("seq");
      seq.model   = apb_env.reg_model;
      seq.start(null);
    end
    
    phase.drop_objection(this, "test");
  endtask
  
  
endclass
