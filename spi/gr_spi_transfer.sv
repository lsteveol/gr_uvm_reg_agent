`ifndef GR_SPI_TRANSFER_SV
`define GR_SPI_TRANSFER_SV

class gr_spi_transfer extends uvm_sequence_item;                                  

  rand bit [31:0]         data;
  rand bit [31:0]         addr;	
  rand gr_spi_mem_type_t  mem_type;
  bit                     err;
   
  `uvm_object_utils_begin(gr_spi_transfer)
    `uvm_field_int  (data,                        UVM_DEFAULT)
    `uvm_field_int  (addr,                        UVM_DEFAULT)
    `uvm_field_int  (err,                         UVM_DEFAULT)
    `uvm_field_enum (gr_spi_mem_type_t, mem_type, UVM_DEFAULT)
  `uvm_object_utils_end

  function new (string name = "gr_spi_transfer");
    super.new(name);
  endfunction

endclass

`endif
