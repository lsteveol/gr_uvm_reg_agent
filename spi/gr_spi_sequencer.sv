`ifndef GR_SPI_SEQUENCER_SV
`define GR_SPI_SEQUENCER_SV

class gr_spi_sequencer extends uvm_sequencer #(gr_spi_transfer);

   `uvm_component_utils(gr_spi_sequencer)
     
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction

endclass

`endif
