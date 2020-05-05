`timescale 1ns/1ps

package ahb_agent_test_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  
  import gr_reg_pkg::*;
  
  import ahb_agent_pkg::*;
  
  `include "tests/ahb_agent_base_test.sv"
  `include "tests/ahb_agent_hw_reset_test.sv"
  `include "tests/ahb_agent_bit_bash_test.sv"
endpackage
