`timescale 1ns/1ps

module ahb_agent_tb_top;

import uvm_pkg::*;
import ahb_agent_pkg::*;
import ahb_agent_test_pkg::*;

reg RegReset  = 1;
reg RegClk    = 0;
always #10ns RegClk <= ~RegClk;


gr_ahb_if ahb_if(.clk(RegClk), .reset(RegReset));

initial begin
  #10ns;
  RegReset = 0;
end

initial begin
  uvm_config_db#(virtual gr_ahb_if)::set(uvm_root::get(), "*", "gr_ahb_if", ahb_if);
  run_test();
end





my_test_ahb_regs_top #(
  //parameters
  .ADDR_WIDTH         ( 8         )
) u_my_test_ahb_regs_top (
  .swi_bf1     (                     ),  //output - [2:0]       
  .swi_bf2     (                     ),  //output - [7:0]       
  .swi_bf3     (                     ),  //output - 1           
  .swi_bf4     (                     ),  //output - [17:0]       
  .swi_bf5     (                     ),  //output - [2:0]       
  .swi_bf6     (                     ),  //output - [3:0]       
  .swi_blabla  (                     ),  //output - [31:0]       
  .RegReset    ( RegReset            ),  //input -  1           
  .RegClk      ( RegClk              ),  //input -  1           
  .hsel        ( ahb_if.hsel         ),  //input -  1              
  .hwrite      ( ahb_if.hwrite       ),  //input -  1              
  .htrans      ( ahb_if.htrans       ),  //input -  [1:0]              
  .hsize       ( ahb_if.hsize        ),  //input -  [2:0]              
  .hburst      ( ahb_if.hburst       ),  //input -  [2:0]              
  .haddr       ( ahb_if.haddr[7:0]   ),  //input -  [(ADDR_WIDTH-1):0]              
  .hwdata      ( ahb_if.hwdata       ),  //input -  [31:0]              
  .hrdata      ( ahb_if.hrdata       ),  //output - [31:0]              
  .hresp       ( ahb_if.hresp        ),  //output - [1:0]              
  .hready      ( ahb_if.hready       )); //output - 1        

endmodule
