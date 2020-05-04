`ifndef GR_APB_ENV_SV
`define GR_APB_ENV_SV
/*
.rst_start
gr_apb_env
==========

Can be used as single source env if you only have a simple uvm_reg_block (i.e. single map/single interface).
If you can't use it due to multiple maps or interfaces then you can just instantiate the agent/adapter/predictors
separately in a higher level env.

Pass the reg_model type as the parameter and it will build the model.


.rst_end
*/
class gr_apb_env #(type REG_MODEL=uvm_reg_block) extends uvm_env;

  gr_apb_agent                            agent;
  gr_apb_reg_adapter                      adapter;
  uvm_reg_predictor#(gr_apb_transfer)     predictor;
  
  REG_MODEL                               reg_model;

  `uvm_component_param_utils_begin(gr_apb_env#(REG_MODEL))
  `uvm_component_utils_end


  function new (string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction


  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Component instances
    agent     = gr_apb_agent        ::type_id::create("agent", this);
    adapter   = gr_apb_reg_adapter  ::type_id::create("adapter");
      
    predictor = uvm_reg_predictor#(gr_apb_transfer)::type_id::create("predictor", this);
    
    reg_model = REG_MODEL           ::type_id::create("reg_model", this);
    reg_model.build();
    //reg_model.lock_model();
    
    uvm_config_object               ::set(null, "*", "reg_model", reg_model);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
        
    predictor.map     = reg_model.MAP_APB;
    predictor.adapter = adapter;
    reg_model.MAP_APB.set_sequencer( .sequencer(agent.sequencer), .adapter(adapter));
    reg_model.MAP_APB.set_auto_predict(0);
    reg_model.add_hdl_path("");
    //agent.monitor.item_collected_port.connect(predictor.bus_in);
  endfunction 

endclass

`endif
