interface gr_ahb_if(input clk, input reset);
  
  logic   [63:0]    haddr;
  logic   [31:0]    hwdata;
  logic   [31:0]    hrdata;
  
  logic             hsel;
  logic             hwrite;
  logic             hready;
  logic   [1:0]     htrans;
  logic   [2:0]     hsize;
  logic   [2:0]     hburst;
  logic   [1:0]     hresp;
  
endinterface
