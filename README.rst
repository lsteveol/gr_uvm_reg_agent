gr_uvm_apb_agent
================
UVM Reg Agent used with the gen_regs flow

.. note ::

  I am not a DV engineer. There are things that you may see here that you disagree with, and that's ok. I use this agent for designer
  testing (and to some extent signoff testing). Some things done here may be against industry norms. I will say setups similar to
  this (and by many counts `worse` than this) have been used to tapeout some of the chips you know and love. 


``gr_reg_pkg.sv``
  Main Package to pull in for registers. Include this repo's base dir and compile this package for simulation

``gr_reg_base_seq.sv``
  Base sequence for register sequences. Extend this so that the sequence will automatically grab the reg_model from
  the ``config_db`` upon creation. When extending from this sequence, a user can easily access the registers with
  the following:
  
  ::
  
    get_reg("MY_REG_REG1");
    set_bf("BF1"        , 0); 
    set_reg();
  
``apb/``
  All APB related components.
  
``ahb/``
  All AHB related components.

Examples
--------
Each of the examples uses the same base registers. The difference is obviously that the interface to the registers is different (APB/AHB). For
this reason, there are two version of the register Verilog file and ``uvm_reg_block``. The ``create_reg_model.csh`` script is used to generate this.


``example_apb``
  An example test environment using the ``gr_apb_env`` for register accesses. Built in UVM test sequences are used. Good starting
  point for new test environments using an APB interface.

``example_ahb``
  An example test environment using the ``gr_ahb_env`` for register accesses. Built in UVM test sequences are used. Good starting
  point for new test environments using an AHB interface.

Dir Structure
-------------
:: 

  |-- README.rst
  |-- ahb
  |   |-- gr_ahb_agent.sv
  |   |-- gr_ahb_driver.sv
  |   |-- gr_ahb_env.sv
  |   |-- gr_ahb_if.sv
  |   |-- gr_ahb_monitor.sv
  |   |-- gr_ahb_reg_adapter.sv
  |   |-- gr_ahb_sequencer.sv
  |   `-- gr_ahb_transfer.sv
  |-- apb
  |   |-- gr_apb_agent.sv
  |   |-- gr_apb_driver.sv
  |   |-- gr_apb_env.sv
  |   |-- gr_apb_if.sv
  |   |-- gr_apb_monitor.sv
  |   |-- gr_apb_reg_adapter.sv
  |   |-- gr_apb_sequencer.sv
  |   `-- gr_apb_transfer.sv
  |-- dut
  |   |-- create_reg_model.csh
  |   |-- my_reg_model.sv
  |   |-- my_reg_model.svh
  |   |-- my_reg_model_ahb.sv
  |   |-- my_reg_model_ahb.svh
  |   |-- my_test_ahb_regs_top.v
  |   |-- my_test_regs_top.v
  |   |-- regs.blk
  |   `-- regs.txt
  |-- example_ahb
  |   |-- run
  |   |   |-- input.tcl
  |   |   |-- simulate.csh
  |   |-- sv
  |   |   |-- ahb_agent_pkg.sv
  |   |   `-- test_seq.sv
  |   |-- tb_top
  |   |   `-- ahb_agent_tb_top.sv
  |   `-- tests
  |       |-- ahb_agent_base_test.sv
  |       |-- ahb_agent_bit_bash_test.sv
  |       |-- ahb_agent_hw_reset_test.sv
  |       `-- ahb_agent_test_pkg.sv
  |-- example_apb
  |   |-- run
  |   |   |-- input.tcl
  |   |   |-- simulate.csh
  |   |-- sv
  |   |   |-- apb_agent_pkg.sv
  |   |   `-- test_seq.sv
  |   |-- tb_top
  |   |   `-- apb_agent_tb_top.sv
  |   `-- tests
  |       |-- apb_agent_base_test.sv
  |       |-- apb_agent_bit_bash_test.sv
  |       |-- apb_agent_hw_reset_test.sv
  |       `-- apb_agent_test_pkg.sv
  |-- gr_reg_base_seq.sv
  `-- gr_reg_pkg.sv

