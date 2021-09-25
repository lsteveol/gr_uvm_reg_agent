`ifndef GR_SPI_DRIVER_SV
`define GR_SPI_DRIVER_SV
/*
.rst_start
gr_spi_driver
=============

.rst_end
*/
class gr_spi_driver #(int ADDR_WIDTH=64) extends uvm_driver #(gr_spi_transfer);
  
  virtual gr_spi_if     vif;
  
  int polling_attempts=10;
  
  //We have to set the SPI Slave CONTROL reg prior to operation
  bit                   spi_slv_contrl_reg_is_set = 0;
  bit [31:0]            miso_rdata;
  
  `uvm_component_param_utils_begin(gr_spi_driver#(ADDR_WIDTH))
  `uvm_component_utils_end
  
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if(!uvm_config_db#(virtual gr_spi_if)::get(this, "", "gr_spi_if", vif))
      `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".gr_spi_if"});

  endfunction
  
  
  virtual task run_phase(uvm_phase phase);
    fork
      reset_signals();
      get_seq_items();
    join
  endtask
  
  virtual task reset_signals();
    forever begin
      //wait(vif.reset);
      @(negedge vif.reset);
      `uvm_info(get_type_name(),$psprintf("Resetting APB Driver"), UVM_DEBUG)
      vif.mosi  <= 1'bx;
      vif.sclk  <= 1'b0;
      vif.ss    <= 1'b1;
    end
  endtask
  
  
  virtual task get_seq_items();
    @(negedge vif.reset);
    forever begin
      seq_item_port.get_next_item(req);
      $cast(rsp, req.clone());
      rsp.set_id_info(req);
      drive_trans(rsp);
      `uvm_info(get_type_name(),$psprintf("seq_item_done rsp = \n%s", rsp.sprint()), UVM_DEBUG)
      seq_item_port.item_done();
      seq_item_port.put_response(rsp);
    end
  endtask
  
  
  
  virtual task drive_trans(gr_spi_transfer trans);
    bit [31:0]  rdata;
    int         cmd_done_max_polls = polling_attempts;   //maximum number of times to check if a command is done before erroring
    int         cmd_done_polls     = 0;
    bit         cmd_done;
    
    `uvm_info(get_type_name(),$psprintf("Inside drive_trans: \n%s", trans.sprint()), UVM_HIGH)
    
    @(posedge vif.clk);
    
    if(!spi_slv_contrl_reg_is_set) begin
      //Clears the CONTROL reg if hasn't been cleared
      `uvm_info(get_type_name(),$psprintf("Clearing SPI Slave CONTROL Register"), UVM_HIGH)
      send_cmd_data(SPI_SEND_SLAVE_WRITE_CONTROL, 'h0, $ceil(ADDR_WIDTH/8));
      spi_slv_contrl_reg_is_set = 1;
      
      #100ns;
    end
    
    
    if(trans.mem_type == SPI_READ) begin
      //------------------------
      // READ Transaction
      //------------------------
      `uvm_info(get_type_name(),$psprintf("Performing SPI Slave READ"), UVM_HIGH)
      send_cmd_data(SPI_SEND_HOST_ADDR_FOR_READ, trans.addr, $ceil(ADDR_WIDTH/8));
      recv_data    (SPI_SEND_SLAVE_READ_STATUS,  rdata);  
      
      //Check for command (APB transaction) completed
      cmd_done = rdata[SPI_STATUS_CMD_DONE];
      while(~cmd_done) begin
        recv_data    (SPI_SEND_SLAVE_READ_STATUS,  rdata);
        cmd_done = rdata[SPI_STATUS_CMD_DONE];
        cmd_done_polls++;
        if(cmd_done_polls >= cmd_done_max_polls) begin
          `uvm_fatal("SPI CMD Done Polling Maxed!",$psprintf("SPI Transaction did not complete in %0d polling attempts!", cmd_done_max_polls));
        end
      end
      
      trans.err = rdata[SPI_STATUS_CMD_ERR];
      
      recv_data    (SPI_SEND_HOST_READ_FOR_DATA, rdata);
      trans.data = rdata;
      
      `uvm_info(get_type_name(),$psprintf("SPI Slave READ Data: 0x%8h", trans.data), UVM_HIGH)
    end else begin
      //------------------------
      // Write Transaction
      //------------------------
      `uvm_info(get_type_name(),$psprintf("Performing SPI Slave READ"), UVM_HIGH)
      send_cmd_data(SPI_SEND_HOST_ADDR_FOR_WRITE, trans.addr, $ceil(ADDR_WIDTH/8));
      send_cmd_data(SPI_SEND_HOST_DATA_FOR_WRITE, trans.data, 4);
      recv_data    (SPI_SEND_SLAVE_READ_STATUS,  rdata);  
      
      //Check for command (APB transaction) completed
      cmd_done = rdata[SPI_STATUS_CMD_DONE];
      while(~cmd_done) begin
        recv_data    (SPI_SEND_SLAVE_READ_STATUS,  rdata);
        cmd_done = rdata[SPI_STATUS_CMD_DONE];
        cmd_done_polls++;
        if(cmd_done_polls >= cmd_done_max_polls) begin
          `uvm_fatal("SPI CMD Done Polling Maxed!",$psprintf("SPI Transaction did not complete in %0d polling attempts!", cmd_done_max_polls));
        end
      end
      
      trans.err = rdata[SPI_STATUS_CMD_ERR];
      
    end
  
    
  endtask
  
  
  /**
    *   Sends a COMMAND and DATA/ADDR
    */
  task send_cmd_data(input gr_spi_cmd_type_t cmd, input bit [63:0] data, input int num_bytes);
    
    @(posedge vif.clk);
    
    vif.ss <= 1'b0;
    
    for(int i=7; i >= 0; i--) begin
      @(negedge vif.clk);
      vif.sclk <= 1'b0;
      vif.mosi <= cmd[i];
      @(posedge vif.clk);
      vif.sclk <= 1'b1;
    end
    
    for(int i=(num_bytes*8)-1; i >= 0; i--) begin
      @(negedge vif.clk);
      vif.sclk <= 1'b0;
      vif.mosi <= data[i];
      @(posedge vif.clk);
      vif.sclk <= 1'b1;
    end
    
    @(posedge vif.clk);
    vif.ss <= 1'b1;
    
  endtask
  
  
  /**
    *   Receives DATA back from the SPI Slave for read
    *   Currently this is always 32bits
    */
  task recv_data(input gr_spi_cmd_type_t cmd, output bit[31:0] rdata);
    miso_rdata = 32'h0;
    
    @(posedge vif.clk);
    
    vif.ss <= 1'b0;
    
    for(int i=7; i >= 0; i--) begin
      @(negedge vif.clk);
      vif.sclk <= 1'b0;
      vif.mosi <= cmd[i];
      @(posedge vif.clk);
      vif.sclk <= 1'b1;
    end
    
    for(int i=31; i >= 0; i--) begin 
      @(negedge vif.clk);
      vif.sclk      <= 1'b0;
      vif.mosi      <= 1'b0;
      @(posedge vif.clk);
      vif.sclk      <= 1'b1;
      miso_rdata[i] <= vif.miso;
      
    end
    
    @(posedge vif.clk);
    vif.ss <= 1'b1;
        
    rdata = miso_rdata;
    
  endtask
  
  
  
  
endclass


`endif
