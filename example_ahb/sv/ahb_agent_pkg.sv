`timescale 1ns/1ps

package ahb_agent_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  
  import gr_reg_pkg::*;
  
  `include "my_reg_model_ahb.sv"
   
  `include "sv/test_seq.sv"
endpackage
