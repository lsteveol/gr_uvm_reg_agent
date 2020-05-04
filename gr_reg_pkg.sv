`include "apb/gr_apb_if.sv"

package gr_reg_pkg;

  import uvm_pkg::*;
  `include "uvm_macros.svh"
  
  typedef enum bit{
    APB_READ      = 0,
    APB_WRITE     = 1
  } gr_apb_mem_type_t;
  
  
  `include "apb/gr_apb_transfer.sv"
  `include "apb/gr_apb_sequencer.sv"
  `include "apb/gr_apb_reg_adapter.sv"
  `include "apb/gr_apb_driver.sv"
  `include "apb/gr_apb_monitor.sv"
  `include "apb/gr_apb_agent.sv"
  `include "apb/gr_apb_env.sv"
  
  `include "gr_reg_base_seq.sv"

endpackage
