`ifndef GR_AHB_DRIVER_SV
`define GR_AHB_DRIVER_SV
/*
.rst_start
gr_ahb_driver
=============

.rst_end
*/
class gr_ahb_driver extends uvm_driver #(gr_ahb_transfer);
  
  virtual gr_ahb_if     vif;
  
  `uvm_component_utils_begin(gr_ahb_driver)
  `uvm_component_utils_end
  
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if(!uvm_config_db#(virtual gr_ahb_if)::get(this, "", "gr_ahb_if", vif))
      `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".gr_ahb_if"});

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
      `uvm_info(get_type_name(),$psprintf("Resetting AHB Driver"), UVM_DEBUG)
      vif.hwdata  <= 'd0;
      vif.haddr   <= 0;
      vif.hsel    <= 0;
      vif.hwrite  <= 0;
      vif.hsize   <= AHB_32BIT;
      vif.hburst  <= AHB_SINGLE;
      vif.htrans  <= AHB_IDLE;
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
  
  
  
  virtual task drive_trans(gr_ahb_transfer trans);
    
    `uvm_info(get_type_name(),$psprintf("Inside drive_trans: \n%s", trans.sprint()), UVM_DEBUG)
    
    @(posedge vif.clk);
    
    //Address Phase
    vif.haddr   <= trans.addr;
    vif.hsel    <= 1;
    vif.htrans  <= AHB_NONSEQ;
    
    vif.hwrite  <= trans.mem_type == AHB_WRITE ? 1          : 0;
    vif.hwdata  <= trans.mem_type == AHB_WRITE ? trans.data : vif.hwdata; //make this randomize?
    
    //Data Phase
    @(posedge vif.clk);
    vif.hwrite  <= 1'bx;
    vif.htrans  <= AHB_IDLE;
    
    
    fork : hready_to
      begin : hready_proc
        do begin
          @(posedge vif.clk);
        end while(vif.hready === 0);
        `uvm_info(get_type_name(),$psprintf("Hready seen"), UVM_DEBUG)
        disable timeout_proc;
      end
      
      begin : timeout_proc
        #10us;
        `uvm_error(get_type_name(), "HREADY not recieved from DUT in 10us");
        trans.err = 1;
      end
    
    join_any
    disable hready_to;
    
    //Get Data if read
    if(trans.mem_type == AHB_READ) begin
      trans.data = vif.hrdata;
      `uvm_info(get_type_name(),$psprintf("PRDATA received %8h", vif.hrdata), UVM_DEBUG)
    end
    
    trans.err   = vif.hresp !== AHB_OK;
    
    vif.hsel    <= 0;    
    
  endtask
  
  
  
  
endclass


`endif
