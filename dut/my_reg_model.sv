//===================================================================
//
// Created by sbridges on May/05/2020 at 07:27:18
//
// my_reg_model.sv
//
//===================================================================



// System:  @ 0x0
//   RegBlock: (MY_REG)                                 @ 0x0



// RegBlock 
class MY_REG_REG1_ extends uvm_reg;
  `uvm_object_utils(MY_REG_REG1_)

  rand uvm_reg_field BF3;
  rand uvm_reg_field BF2;
  rand uvm_reg_field BF1;

  function new (string name = "MY_REG_REG1_");
    super.new(name, 32, UVM_NO_COVERAGE);
  endfunction

  //Addr        : 0x0        (Includes Map Offset)
  //Map         : MAP_APB     0x0
  //Reset       : 0x804     
  //Description : 
  function void build;
    //Description: 
    BF3 = uvm_reg_field::type_id::create("BF3");  //    MY_REG_REG1__BF3
    BF3.configure(this, 1, 11, "RW", 0, 'h1, 1, 1, 0);
    //Description: 
    BF2 = uvm_reg_field::type_id::create("BF2");  //    MY_REG_REG1__BF2
    BF2.configure(this, 8, 3, "RW", 0, 'h0, 1, 1, 0);
    //Description: 
    BF1 = uvm_reg_field::type_id::create("BF1");  //    MY_REG_REG1__BF1
    BF1.configure(this, 3, 0, "RW", 0, 'h4, 1, 1, 0);
  endfunction
endclass

class MY_REG_REG2_ extends uvm_reg;
  `uvm_object_utils(MY_REG_REG2_)

  rand uvm_reg_field BF5;
  rand uvm_reg_field RESERVED00;
  rand uvm_reg_field BF4;

  function new (string name = "MY_REG_REG2_");
    super.new(name, 32, UVM_NO_COVERAGE);
  endfunction

  //Addr        : 0x4        (Includes Map Offset)
  //Map         : MAP_APB     0x0
  //Reset       : 0x70004d2 
  //Description : 
  function void build;
    //Description: 
    BF5 = uvm_reg_field::type_id::create("BF5");  //    MY_REG_REG2__BF5
    BF5.configure(this, 3, 24, "RW", 0, 'h7, 1, 1, 0);
    //Description: 
    RESERVED00 = uvm_reg_field::type_id::create("RESERVED00");  //MY_REG_REG2__RESERVED00
    RESERVED00.configure(this, 6, 18, "RO", 0, 'h0, 1, 1, 0);
    //Description: 
    BF4 = uvm_reg_field::type_id::create("BF4");  //    MY_REG_REG2__BF4
    BF4.configure(this, 18, 0, "RW", 0, 'h4d2, 1, 1, 0);
  endfunction
endclass

class MY_REG_REG3_ extends uvm_reg;
  `uvm_object_utils(MY_REG_REG3_)

  rand uvm_reg_field BF6;

  function new (string name = "MY_REG_REG3_");
    super.new(name, 32, UVM_NO_COVERAGE);
  endfunction

  //Addr        : 0x8        (Includes Map Offset)
  //Map         : MAP_APB     0x0
  //Reset       : 0x5       
  //Description : 
  function void build;
    //Description: 
    BF6 = uvm_reg_field::type_id::create("BF6");  //    MY_REG_REG3__BF6
    BF6.configure(this, 4, 0, "RW", 0, 'h5, 1, 1, 0);
  endfunction
endclass

class MY_REG_REG4_ extends uvm_reg;
  `uvm_object_utils(MY_REG_REG4_)

  rand uvm_reg_field BLABLA;

  function new (string name = "MY_REG_REG4_");
    super.new(name, 32, UVM_NO_COVERAGE);
  endfunction

  //Addr        : 0xc        (Includes Map Offset)
  //Map         : MAP_APB     0x0
  //Reset       : 0x1e240   
  //Description : 
  function void build;
    //Description: 
    BLABLA = uvm_reg_field::type_id::create("BLABLA");  // MY_REG_REG4__BLABLA
    BLABLA.configure(this, 32, 0, "RW", 0, 'h1e240, 1, 1, 0);
  endfunction
endclass

class my_reg_model extends uvm_reg_block;
  `uvm_object_utils(my_reg_model)

  //RegBlock 
  rand MY_REG_REG1_                                       MY_REG_REG1;
  rand MY_REG_REG2_                                       MY_REG_REG2;
  rand MY_REG_REG3_                                       MY_REG_REG3;
  rand MY_REG_REG4_                                       MY_REG_REG4;

  //Reg Map Declarations
  uvm_reg_map MAP_APB;

  function new (string name = "my_reg_model");
    super.new(name);
  endfunction

  function void build();

    MAP_APB      = create_map("MAP_APB", 32'h0, 4, UVM_LITTLE_ENDIAN);
    this.MY_REG_REG1 = MY_REG_REG1_::type_id::create("MY_REG_REG1");
    this.MY_REG_REG1.build();
    this.MY_REG_REG1.configure(this);
    this.MY_REG_REG1.add_hdl_path_slice("MY_REG_REG1", 32'h0, 32);
    MAP_APB.add_reg(MY_REG_REG1, 32'h0, "RW");

    this.MY_REG_REG2 = MY_REG_REG2_::type_id::create("MY_REG_REG2");
    this.MY_REG_REG2.build();
    this.MY_REG_REG2.configure(this);
    this.MY_REG_REG2.add_hdl_path_slice("MY_REG_REG2", 32'h4, 32);
    MAP_APB.add_reg(MY_REG_REG2, 32'h4, "RW");

    //THIS REG HAS BEEN DEFINED AS NO_REG_TEST
    this.MY_REG_REG3 = MY_REG_REG3_::type_id::create("MY_REG_REG3");
    this.MY_REG_REG3.build();
    this.MY_REG_REG3.configure(this);
    this.MY_REG_REG3.add_hdl_path_slice("MY_REG_REG3", 32'h8, 32);
    MAP_APB.add_reg(MY_REG_REG3, 32'h8, "RW");

    uvm_resource_db#(bit)::set(.scope("REG::*MY_REG_REG3"), .name("NO_REG_TESTS"), .val(1), .accessor(this));
    this.MY_REG_REG4 = MY_REG_REG4_::type_id::create("MY_REG_REG4");
    this.MY_REG_REG4.build();
    this.MY_REG_REG4.configure(this);
    this.MY_REG_REG4.add_hdl_path_slice("MY_REG_REG4", 32'hc, 32);
    MAP_APB.add_reg(MY_REG_REG4, 32'hc, "RW");

    this.lock_model();
  endfunction
endclass
