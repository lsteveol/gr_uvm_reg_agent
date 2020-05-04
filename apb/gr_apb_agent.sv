`ifndef GR_APB_AGENT_SV
`define GR_APB_AGENT_SV

class gr_apb_agent extends uvm_agent;
  
  `uvm_component_utils_begin(gr_apb_agent)
  `uvm_component_utils_end
  
  gr_apb_driver       driver;
  gr_apb_sequencer    sequencer;
  gr_apb_monitor      monitor;

  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    monitor           = gr_apb_monitor::type_id::create("monitor", this);

    if(get_is_active() == UVM_ACTIVE) begin
	    `uvm_info(get_type_name(), $psprintf("GR APB Agent is UVM_ACTIVE"), UVM_MEDIUM);
      sequencer       = gr_apb_sequencer::type_id::create("sequencer", this);
      driver          = gr_apb_driver::type_id::create("driver", this);
    end
  endfunction

  function void connect_phase(uvm_phase phase);
    if(get_is_active() == UVM_ACTIVE) begin
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction

endclass

`endif
