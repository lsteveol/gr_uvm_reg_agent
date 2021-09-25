interface gr_apb_if (input clk, input reset);
  
  logic   [63:0]    paddr;
  logic   [31:0]    pwdata;
  logic   [31:0]    prdata;
  
  logic             psel      = 0;
  logic             penable   = 0;
  logic             pwrite    = 0;
  logic             pready;
  logic             pslverr;
  logic [31:0]      INPUT_SKEW = 2;
  logic [31:0]      OUTPUT_SKEW = 2;
  
  clocking cb @(posedge clk);
     default input #INPUT_SKEW output #OUTPUT_SKEW;
     output psel, penable, pwrite, paddr, pwdata;
     input  pready, prdata, pslverr;
  endclocking 
  
  //modport drv (input reset, clocking cb);
  
  
endinterface
