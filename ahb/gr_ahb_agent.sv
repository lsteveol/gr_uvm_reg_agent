`ifndef GR_AHB_AGENT_SV
`define GR_AHB_AGENT_SV

class gr_ahb_agent extends uvm_agent;
  
  `uvm_component_utils_begin(gr_ahb_agent)
  `uvm_component_utils_end
  
  gr_ahb_driver       driver;
  gr_ahb_sequencer    sequencer;
  gr_ahb_monitor      monitor;

  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    monitor           = gr_ahb_monitor::type_id::create("monitor", this);

    if(get_is_active() == UVM_ACTIVE) begin
	    `uvm_info(get_type_name(), $psprintf("GR AHB Agent is UVM_ACTIVE"), UVM_MEDIUM);
      sequencer       = gr_ahb_sequencer::type_id::create("sequencer", this);
      driver          = gr_ahb_driver::type_id::create("driver", this);
    end
  endfunction

  function void connect_phase(uvm_phase phase);
    if(get_is_active() == UVM_ACTIVE) begin
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction

endclass

`endif
