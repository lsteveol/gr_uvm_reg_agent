`ifndef GR_SPI_AGENT_SV
`define GR_SPI_AGENT_SV

class gr_spi_agent#(int ADDR_WIDTH=64) extends uvm_agent;
  
  `uvm_component_param_utils_begin(gr_spi_agent#(ADDR_WIDTH))
  `uvm_component_utils_end
  
  gr_spi_driver#(ADDR_WIDTH)       driver;
  gr_spi_sequencer    sequencer;
  gr_spi_monitor      monitor;
  int                 polling_attempts = 10;

  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    monitor           = gr_spi_monitor::type_id::create("monitor", this);

    if(get_is_active() == UVM_ACTIVE) begin
	    `uvm_info(get_type_name(), $psprintf("GR SPI Agent is UVM_ACTIVE"), UVM_MEDIUM);
      
      uvm_config_db#(int)::get(this, "", "polling_attempts", polling_attempts);
      
      sequencer       = gr_spi_sequencer::type_id::create("sequencer", this);
      driver          = gr_spi_driver#(ADDR_WIDTH)::type_id::create("driver", this);
      driver.polling_attempts = polling_attempts;
    end
  endfunction

  function void connect_phase(uvm_phase phase);
    if(get_is_active() == UVM_ACTIVE) begin
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction

endclass

`endif
