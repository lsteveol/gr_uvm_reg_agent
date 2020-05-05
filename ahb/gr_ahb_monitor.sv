`ifndef GR_AHB_MONITOR_SV
`define GR_AHB_MONITOR_SV
/*
.rst_start
gr_ahb_monitor
=============

.rst_end
*/
class gr_ahb_monitor extends uvm_monitor;

  virtual gr_ahb_if   vif;
  bit                 monitor_enable = 1;
  
  
  // Analysis port for the collected transfer.
  uvm_analysis_port #(gr_ahb_transfer) item_collected_port;
  
  `uvm_component_utils_begin(gr_ahb_monitor)
  `uvm_component_utils_end
  
  
  function new (string name, uvm_component parent);
    super.new(name, parent);
    
    item_collected_port = new("item_collected_port", this);
    
  endfunction

  function void build_phase(uvm_phase phase);
  endfunction
  

  virtual task run_phase(uvm_phase phase);
  endtask
  
  // Collects a transfer.
  task collect_transfers();
        
  endtask
  
  
endclass
`endif
