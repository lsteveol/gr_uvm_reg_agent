`ifndef GR_SPI_MONITOR_SV
`define GR_SPI_MONITOR_SV
/*
.rst_start
gr_spi_monitor
=============

.rst_end
*/
class gr_spi_monitor extends uvm_monitor;

  virtual gr_spi_if   vif;
  bit                 monitor_enable = 1;
  
  
  // Analysis port for the collected transfer.
  uvm_analysis_port #(gr_spi_transfer) item_collected_port;
  
  `uvm_component_utils_begin(gr_spi_monitor)
  `uvm_component_utils_end
  
  
  function new (string name, uvm_component parent);
    super.new(name, parent);
    
    item_collected_port = new("item_collected_port", this);
    
  endfunction

  function void build_phase(uvm_phase phase);
  
    if(!uvm_config_db#(virtual gr_spi_if)::get(this, "", "gr_spi_if", vif))
      `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".gr_spi_if"});
      
  endfunction
  

  virtual task run_phase(uvm_phase phase);
     if(monitor_enable) begin
        collect_transfers();
     end 
  endtask
  
  // Collects a transfer.
  task collect_transfers();
    
    gr_spi_transfer transfer;
    gr_spi_transfer transfer_clone;
    
//     forever begin
//       @(posedge vif.clk);
//       
//       //Setup
//       //while(vif.psel !== 1) begin
//       //  @(posedge vif.clk);
//       //end
//       
//       @(posedge vif.clk);
//       
//       //Access
//       //if(vif.penable !== 0) begin
//       //  `uvm_error(get_type_name(), "PENABLE not high on cycle after PSEL");
//       //end
//       
//       //wait(vif.pready);
//       
// //       transfer            = gr_spi_transfer::type_id::create("trans");
// //       transfer.addr       = vif.paddr;
// //       transfer.mem_type   = vif.pwrite ? SPI_WRITE  : SPI_READ;
// //       transfer.data       = vif.pwrite ? vif.pwdata : vif.prdata;
// //       transfer.err        = vif.pslverr;
//       
//       `uvm_info(get_type_name(),$psprintf("Completed transfer collection\n%s", transfer.sprint()), UVM_DEBUG)
//       
//       $cast(transfer_clone, transfer.clone());
//       
//       `uvm_info(get_type_name(),$psprintf("Cloned transfer\n%s", transfer_clone.sprint()), UVM_DEBUG)
//       item_collected_port.write(transfer_clone);
//       
//       //@(negedge vif.penable);
//       
//     end
    
  endtask
  
  
endclass
`endif
