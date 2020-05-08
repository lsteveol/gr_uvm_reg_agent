`timescale 1ns/1ps

`include "apb/gr_apb_if.sv"
`include "ahb/gr_ahb_if.sv"

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
  
  
  typedef enum bit{
    AHB_READ      = 0,
    AHB_WRITE     = 1
  } gr_ahb_mem_type_t;
  
  typedef enum bit[1:0]{
    AHB_IDLE      = 2'b00,
    AHB_BUSY      = 2'b01,
    AHB_NONSEQ    = 2'b10,
    AHB_SEQ       = 2'b11
  } gr_ahb_htrans_t;
  
  typedef enum bit[2:0]{
    AHB_8BIT      = 3'b000,
    AHB_16BIT     = 3'b001,
    AHB_32BIT     = 3'b010,   //more than likely we only ever use this
    AHB_64BIT     = 3'b011,
    AHB_128BIT    = 3'b100,
    AHB_256BIT    = 3'b101,
    AHB_512BIT    = 3'b110,
    AHB_1024BIT   = 3'b111
  } gr_ahb_hsize_t;
  
  typedef enum bit[2:0]{
    AHB_SINGLE    = 3'b000    //probably only ever supporting this
  } gr_ahb_hburst_t;
  
  typedef enum bit[1:0]{
    AHB_OK        = 2'b00,
    AHB_ERR       = 2'b01
  } gr_ahb_hresp_t;
  
  `include "ahb/gr_ahb_transfer.sv"
  `include "ahb/gr_ahb_sequencer.sv"
  `include "ahb/gr_ahb_reg_adapter.sv"
  `include "ahb/gr_ahb_driver.sv"
  `include "ahb/gr_ahb_monitor.sv"
  `include "ahb/gr_ahb_agent.sv"
  `include "ahb/gr_ahb_env.sv"
  
  `include "gr_reg_base_seq.sv"
  
  //Test Sequences since the UVM ones are doo doo
  `include "sequences/gr_reg_hw_reset_seq.sv"
  `include "sequences/gr_reg_bit_bash_seq.sv"

endpackage
