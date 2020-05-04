`ifndef GR_APB_SEQUENCER_SV
`define GR_APB_SEQUENCER_SV

class gr_apb_sequencer extends uvm_sequencer #(gr_apb_transfer);

   `uvm_component_utils(gr_apb_sequencer)
     
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction

endclass

`endif
