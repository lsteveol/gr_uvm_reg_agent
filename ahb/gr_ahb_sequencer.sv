`ifndef GR_AHB_SEQUENCER_SV
`define GR_AHB_SEQUENCER_SV

class gr_ahb_sequencer extends uvm_sequencer #(gr_ahb_transfer);

   `uvm_component_utils(gr_ahb_sequencer)
     
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction

endclass

`endif
