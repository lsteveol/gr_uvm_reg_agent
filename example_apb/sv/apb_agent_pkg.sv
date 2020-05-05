`timescale 1ns/1ps

package apb_agent_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  
  import gr_reg_pkg::*;
  
  //`include "sv/register/my_reg_model.sv"
  `include "my_reg_model.sv"
   
  `include "sv/test_seq.sv"
endpackage
