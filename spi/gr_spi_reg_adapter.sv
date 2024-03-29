`ifndef GR_SPI_REG_ADAPTER_SV
`define GR_SPI_REG_ADAPTER_SV

class gr_spi_reg_adapter extends uvm_reg_adapter;
  `uvm_object_utils(gr_spi_reg_adapter)

  function new (string name = "gr_spi_reg_adapter");
    super.new(name);
    provides_responses = 1;
  endfunction

  function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
    gr_spi_transfer transfer;

    transfer            = gr_spi_transfer::type_id::create("transfer");
    transfer.addr       = rw.addr;
    transfer.data       = rw.data;
    transfer.mem_type   = (rw.kind == UVM_READ) ? SPI_READ : SPI_WRITE;

    `uvm_info(get_type_name(), $psprintf("reg2bus: Transfer Address:%h Data:%h Direction:%s",transfer.addr, transfer.data, transfer.mem_type.name), UVM_FULL)

    return transfer;
  endfunction

  function void bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
    gr_spi_transfer transfer;

    if(!$cast(transfer, bus_item) ) begin
      `uvm_fatal("NOT_REG_TYPE", "Incorrect bus item type. Expecting gr_spi_transfer")
      return;
    end

      rw.kind = (transfer.mem_type == SPI_WRITE) ? UVM_WRITE : UVM_READ;
      rw.addr = transfer.addr;
      rw.data = transfer.data;  // For monitoring, need write data as well as read data
      //rw.status = UVM_IS_OK;
      rw.status = transfer.err ? UVM_NOT_OK : UVM_IS_OK;

     `uvm_info(get_type_name(), $psprintf("bus2reg: Transfer Address:%h Data:%h Direction:%s.",transfer.addr, transfer.data, transfer.mem_type.name), UVM_FULL)

  endfunction

endclass

`endif
