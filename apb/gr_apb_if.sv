interface gr_apb_if(input clk, input reset);
  
  logic   [63:0]    paddr;
  logic   [31:0]    pwdata;
  logic   [31:0]    prdata;
  
  logic             psel;
  logic             penable;
  logic             pwrite;
  logic             pready;
  logic             pslverr;
  
endinterface
