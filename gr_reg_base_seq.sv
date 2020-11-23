`ifndef GR_REG_BASE_SV
`define GR_REG_BASE_SV

/*
.rst_start
gr_reg_base
===========

Base sequence for register sequences. Can actually be used for just about anything.

Do we need a p_sequencer????
.rst_end
*/

class gr_reg_base_seq #(type REQ = uvm_sequence_item, type RSP = REQ) extends uvm_sequence #(REQ,RSP);

  uvm_reg_block reg_model;
  uvm_status_e  status;
  uvm_reg       write_reg;
  uvm_reg       read_reg;
  reg [31:0]    VAL;
  
  uvm_reg        local_reg;
  uvm_reg_field  local_reg_field;


  function new(string name="gr_reg_base");
		super.new(name);
    get_model();  //can we do this?
	endfunction
  

  virtual function void get_model();
    uvm_object temp_object;
    uvm_reg_block temp_reg_block;

    if(reg_model == null) begin
      if(uvm_config_object::get(null, "*", "reg_model", temp_object)) begin
        if(!($cast(reg_model,temp_object)))
      	  `uvm_fatal("BAD_CONFIG", "Sequence reg model is inocrrect");
      end else if (uvm_config_db #(uvm_reg_block)::get(null, "*", "reg_model", temp_reg_block)) begin
       if(!($cast(reg_model, temp_reg_block)))
      	 `uvm_fatal("ERROR_ID", "class_name not found in the UVM factory!");
      end else begin
        `uvm_fatal("NO_REG_CONFIG", "Reg Model is not set, Exiting");
      end
    end
  endfunction : get_model


  virtual task pre_start();
    super.pre_start();
    get_model();
    
  endtask
  
  
// 	virtual task pre_body();
// 		if (starting_phase!=null) begin
//       starting_phase.raise_objection(this);
// 		end
// 	endtask
// 
// 	virtual task post_body();
// 		if (starting_phase!=null) begin
// 			`uvm_info(get_type_name(),
// 				$sformatf("%s post_body() dropping %s objection",
// 					get_sequence_path(),
// 					starting_phase.get_name()), UVM_MEDIUM);
// 			starting_phase.drop_objection(this);
// 		end
// 	endtask


  //Performs a read from the DUT, updates the VAL variable as old method.
  //should be preformed prior to any get_bf/set_bf functions
  virtual task get_reg(string reg_name);
    local_reg = reg_model.get_reg_by_name(reg_name);
    local_reg.read(status, VAL);
    local_reg.predict(VAL);
    //local_reg.print();
    //$display("%s read: %8h", reg_name, VAL);
  endtask

  //MUST BE CALLED AFTER get_reg
  //Returns the value of the bitfield
  function bit[31:0] get_bf(string bf_name);
    local_reg_field = local_reg.get_field_by_name(bf_name);
    return local_reg_field.get();
  endfunction

  //Sets the value of the bitfield (in the uvm_reg_model), a write
  //is still required to force a DUT transaction
  virtual task set_bf(string bf_name, bit [31:0] wval);
    local_reg_field = local_reg.get_field_by_name(bf_name);
    local_reg_field.set(wval);
    //local_reg.print();
    //$display("update: %8h", local_reg.get());
  endtask

  //virtual task set_reg(string reg_name = "NULL", input bit[31:0] wval = null);
  //XRUN has issue with setting wval to null, so this was the only workaround I could think of
  virtual task set_reg(string reg_name = "NULL", input bit[32:0] wval = 33'h1_0000_0000);
    if(reg_name != "NULL") begin
      //Just a write with value
      local_reg = reg_model.get_reg_by_name(reg_name);
      local_reg.write(status, wval[31:0]);
    end else begin
      //You did a previous read
      if(wval != 33'h1_0000_0000) begin   //<--- what a hack
        local_reg.write(status, wval[31:0]);
      end else begin
        local_reg.write(status, local_reg.get());
      end
    end
  endtask

endclass

`endif
