`timescale 1ns/1ps

module apb_agent_tb_top;

import uvm_pkg::*;
import apb_agent_pkg::*;
import apb_agent_test_pkg::*;

reg RegReset  = 1;
reg RegClk    = 0;
always #10ns RegClk <= ~RegClk;


gr_apb_if apb_if(.clk(RegClk), .reset(RegReset));

initial begin
  #10ns;
  RegReset = 0;
end

initial begin
  uvm_config_db#(virtual gr_apb_if)::set(uvm_root::get(), "*", "gr_apb_if", apb_if);
  run_test();
end




my_test_regs_top #(
  //parameters
  .ADDR_WIDTH         ( 8         )
) u_my_test_regs_top (
  .swi_bf1     (       ),  //output - [2:0]              
  .swi_bf2     (       ),  //output - [7:0]              
  .swi_bf3     (       ),  //output - 1              
  .swi_bf4     (       ),  //output - [17:0]              
  .swi_bf5     (       ),  //output - [2:0]              
  .RegReset    ( RegReset            ),  //input -  1              
  .RegClk      ( RegClk              ),  //input -  1              
  .PSEL        ( apb_if.psel         ),  //input -  1              
  .PENABLE     ( apb_if.penable      ),  //input -  1              
  .PWRITE      ( apb_if.pwrite       ),  //input -  1              
  .PSLVERR     ( apb_if.pslverr      ),  //output - 1              
  .PREADY      ( apb_if.pready       ),  //output - 1              
  .PADDR       ( apb_if.paddr        ),  //input -  [(ADDR_WIDTH-1):0]              
  .PWDATA      ( apb_if.pwdata       ),  //input -  [31:0]              
  .PRDATA      ( apb_if.prdata       )); //output - [31:0]  

endmodule
