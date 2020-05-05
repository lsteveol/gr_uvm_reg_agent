`timescale 1ns/1ps

package apb_agent_test_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  
  import gr_reg_pkg::*;
  
  import apb_agent_pkg::*;
  
  `include "tests/apb_agent_base_test.sv"
  `include "tests/apb_agent_hw_reset_test.sv"
  `include "tests/apb_agent_bit_bash_test.sv"
endpackage
