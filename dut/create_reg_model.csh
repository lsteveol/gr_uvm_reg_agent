#!/bin/csh -f

set    blk_name   = regs.blk

#####################
# APB
#####################

set    reg_model  = my_reg_model

if(-e $blk_name) then
  rm $blk_name
  touch $blk_name
endif
echo "BLK:regs.txt    N/A   my    reg    0x0000" >> $blk_name

gen_regs_py       -i regs.txt -p my -b test
gen_uvm_reg_model -b $blk_name -o ${reg_model}


#####################
# AHB
#####################
set    reg_model  = my_reg_model_ahb

if(-e $blk_name) then
  rm $blk_name
  touch $blk_name
endif
echo "MAP:            MAP_AHB            0x0000" >> $blk_name
echo "BLK:regs.txt    N/A   my    reg    0x0000" >> $blk_name

gen_regs_py       -i regs.txt -p my -b test_ahb -ahb
gen_uvm_reg_model -b $blk_name -o ${reg_model}


