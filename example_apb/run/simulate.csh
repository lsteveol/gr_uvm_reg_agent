#!/bin/csh -f

if($#argv < 1) then
  echo "No test defined!"
  echo "Usage:"
  echo "       $0 <test>"
  exit 1
endif



set DUT_DIR = ../../dut
set TB_BASE = ../

set GR_PKG  = "+incdir+../../ \
               ../../gr_reg_pkg.sv"


xrun -stop_on_build_error  -sv  -64bit   -licqueue -warn_multiple_driver -errormax 1 \
  -timescale "1ns/1ps" -l xrun.log -uvm -access rwc -input input.tcl -fsmdebug \
  $GR_PKG \
  +incdir+$TB_BASE \
  +incdir+$DUT_DIR \
  $TB_BASE/sv/apb_agent_pkg.sv \
  $TB_BASE/tests/apb_agent_test_pkg.sv \
  $TB_BASE/tb_top/apb_agent_tb_top.sv \
  $DUT_DIR/*.v +UVM_TESTNAME=$argv[1] 
