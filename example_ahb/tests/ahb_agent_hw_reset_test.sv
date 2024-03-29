class ahb_agent_hw_reset_test extends ahb_agent_base_test;
  
  `uvm_component_utils(ahb_agent_hw_reset_test)
  
  function new(string name = "ahb_agent_hw_reset_test", uvm_component parent=null);
    super.new(name,parent);
  endfunction 
  
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction
  
  
  task run_phase(uvm_phase phase);
    phase.raise_objection(this, "test");
    
    super.run_phase(phase);
    
    begin
      gr_reg_hw_reset_seq    seq;
      
      seq         = gr_reg_hw_reset_seq::type_id::create("seq");
      seq.model   = ahb_env.reg_model;
      seq.start(null);
    end
    
    phase.drop_objection(this, "test");
  endtask
  
  
endclass
