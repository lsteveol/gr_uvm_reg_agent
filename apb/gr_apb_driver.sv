`ifndef GR_APB_DRIVER_SV
`define GR_APB_DRIVER_SV
/*
.rst_start
gr_apb_driver
=============

.rst_end
*/
class gr_apb_driver extends uvm_driver #(gr_apb_transfer);
  
  virtual gr_apb_if     vif;
  
  `uvm_component_utils_begin(gr_apb_driver)
  `uvm_component_utils_end
  
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if(!uvm_config_db#(virtual gr_apb_if)::get(this, "", "gr_apb_if", vif))
      `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".gr_apb_if"});

  endfunction
  
  
  virtual task run_phase(uvm_phase phase);
    fork
      reset_signals();
      get_seq_items();
    join
  endtask
  
  virtual task reset_signals();
    forever begin
      //wait(vif.cb.reset);
      @(negedge vif.reset);
      `uvm_info(get_type_name(),$psprintf("Resetting APB Driver"), UVM_DEBUG)
      vif.cb.pwdata  <= 'd0;
      vif.cb.paddr   <= 0;
      vif.cb.penable <= 0;
      vif.cb.psel    <= 0;
      vif.cb.pwrite  <= 0;
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
  
  
  
  virtual task drive_trans(gr_apb_transfer trans);
    
    `uvm_info(get_type_name(),$psprintf("Inside drive_trans: \n%s", trans.sprint()), UVM_DEBUG)
    
    @(vif.cb);
    
    //Address Phase
    vif.cb.paddr   <= trans.addr;
    vif.cb.psel    <= 1;
    vif.cb.penable <= 0;
    
    vif.cb.pwrite  <= trans.mem_type == APB_WRITE ? 1          : 0;
    vif.cb.pwdata  <= trans.mem_type == APB_WRITE ? trans.data : vif.cb.pwdata; //make this randomize?
    
    //Data Phase
    @(vif.cb);
    vif.cb.penable <= 1;
    
    
    fork : pready_to
      begin : pready_proc
        do begin
          @(vif.cb);
        end while(vif.cb.pready === 0);
        `uvm_info(get_type_name(),$psprintf("Pready seen"), UVM_DEBUG)
        disable timeout_proc;
      end
      
      begin : timeout_proc
        #100us;
        `uvm_error(get_type_name(), "PREADY not recieved from DUT in 100us");
        trans.err = 1;
      end
    
    join_any
    disable pready_to;
    
    //Get Data if read
    if(trans.mem_type == APB_READ) begin
      trans.data = vif.cb.prdata;
      `uvm_info(get_type_name(),$psprintf("PRDATA received %8h", vif.cb.prdata), UVM_DEBUG)
    end
    
    trans.err   = vif.cb.pslverr;
    
    if(vif.cb.pslverr) begin
      `uvm_error(get_type_name(), "PSLVERR Seen");
    end
    
    vif.cb.psel    <= 0;
    vif.cb.penable <= 0;
    vif.cb.pwrite  <= 0;    
    
  endtask
  
  
  
  
endclass


`endif
