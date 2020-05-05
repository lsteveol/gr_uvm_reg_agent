//===================================================================
//
// Created by sbridges on May/05/2020 at 07:27:18
//
// my_test_regs_top.v
//
//===================================================================



module my_test_regs_top #(
  parameter    ADDR_WIDTH = 8
)(
  //REG1
  output wire [2:0]   swi_bf1,
  output wire [7:0]   swi_bf2,
  output wire         swi_bf3,
  //REG2
  output wire [17:0]  swi_bf4,
  output wire [2:0]   swi_bf5,
  //REG3
  output wire [3:0]   swi_bf6,
  //REG4
  output wire [31:0]  swi_blabla,

  //DFT Ports (if used)
  
  // APB Interface
  input  wire RegReset,
  input  wire RegClk,
  input  wire PSEL,
  input  wire PENABLE,
  input  wire PWRITE,
  output wire PSLVERR,
  output wire PREADY,
  input  wire [(ADDR_WIDTH-1):0] PADDR,
  input  wire [31:0] PWDATA,
  output wire [31:0] PRDATA
);
  
  //DFT Tieoffs (if not used)
  wire dft_core_scan_mode = 1'b0;
  wire dft_iddq_mode = 1'b0;
  wire dft_hiz_mode = 1'b0;
  wire dft_bscan_mode = 1'b0;

  //APB Setup/Access 
  wire [(ADDR_WIDTH-1):0] RegAddr_in;
  reg  [(ADDR_WIDTH-1):0] RegAddr;
  wire [31:0] RegWrData_in;
  reg  [31:0] RegWrData;
  wire RegWrEn_in;
  reg  RegWrEn_pq;
  wire RegWrEn;

  assign RegAddr_in = PSEL ? PADDR : RegAddr; 

  always @(posedge RegClk or posedge RegReset) begin
    if (RegReset) begin
      RegAddr <= {(ADDR_WIDTH){1'b0}};
    end else begin
      RegAddr <= RegAddr_in;
    end
  end

  assign RegWrData_in = PSEL ? PWDATA : RegWrData; 

  always @(posedge RegClk or posedge RegReset) begin
    if (RegReset) begin
      RegWrData <= 32'h00000000;
    end else begin
      RegWrData <= RegWrData_in;
    end
  end

  assign RegWrEn_in = PSEL & PWRITE;

  always @(posedge RegClk or posedge RegReset) begin
    if (RegReset) begin
      RegWrEn_pq <= 1'b0;
    end else begin
      RegWrEn_pq <= RegWrEn_in;
    end
  end

  assign RegWrEn = RegWrEn_pq & PENABLE;
  
  //assign PSLVERR = 1'b0;
  assign PREADY  = 1'b1;
  


  //Regs for Mux Override sel



  //---------------------------
  // REG1
  // bf1 - 
  // bf2 - 
  // bf3 - 
  //---------------------------
  wire [31:0] REG1_reg_read;
  reg [2:0]   reg_bf1;
  reg [7:0]   reg_bf2;
  reg         reg_bf3;

  always @(posedge RegClk or posedge RegReset) begin
    if(RegReset) begin
      reg_bf1                                <= 3'h4;
      reg_bf2                                <= 8'h0;
      reg_bf3                                <= 1'h1;
    end else if(RegAddr == 'h0 && RegWrEn) begin
      reg_bf1                                <= RegWrData[2:0];
      reg_bf2                                <= RegWrData[10:3];
      reg_bf3                                <= RegWrData[11];
    end else begin
      reg_bf1                                <= reg_bf1;
      reg_bf2                                <= reg_bf2;
      reg_bf3                                <= reg_bf3;
    end
  end

  assign REG1_reg_read = {20'h0,
          reg_bf3,
          reg_bf2,
          reg_bf1};

  //-----------------------
  assign swi_bf1 = reg_bf1;

  //-----------------------
  assign swi_bf2 = reg_bf2;

  //-----------------------
  assign swi_bf3 = reg_bf3;





  //---------------------------
  // REG2
  // bf4 - 
  // reserved0 - 
  // bf5 - 
  //---------------------------
  wire [31:0] REG2_reg_read;
  reg [17:0]  reg_bf4;
  reg [2:0]   reg_bf5;

  always @(posedge RegClk or posedge RegReset) begin
    if(RegReset) begin
      reg_bf4                                <= 18'h4d2;
      reg_bf5                                <= 3'h7;
    end else if(RegAddr == 'h4 && RegWrEn) begin
      reg_bf4                                <= RegWrData[17:0];
      reg_bf5                                <= RegWrData[26:24];
    end else begin
      reg_bf4                                <= reg_bf4;
      reg_bf5                                <= reg_bf5;
    end
  end

  assign REG2_reg_read = {5'h0,
          reg_bf5,
          6'd0, //Reserved
          reg_bf4};

  //-----------------------
  assign swi_bf4 = reg_bf4;

  //-----------------------
  //-----------------------
  assign swi_bf5 = reg_bf5;





  //---------------------------
  // REG3
  // bf6 - 
  //---------------------------
  wire [31:0] REG3_reg_read;
  reg [3:0]   reg_bf6;

  always @(posedge RegClk or posedge RegReset) begin
    if(RegReset) begin
      reg_bf6                                <= 4'h5;
    end else if(RegAddr == 'h8 && RegWrEn) begin
      reg_bf6                                <= RegWrData[3:0];
    end else begin
      reg_bf6                                <= reg_bf6;
    end
  end

  assign REG3_reg_read = {28'h0,
          reg_bf6};

  //-----------------------
  assign swi_bf6 = reg_bf6;





  //---------------------------
  // REG4
  // blabla - 
  //---------------------------
  wire [31:0] REG4_reg_read;
  reg [31:0]  reg_blabla;

  always @(posedge RegClk or posedge RegReset) begin
    if(RegReset) begin
      reg_blabla                             <= 32'h1e240;
    end else if(RegAddr == 'hc && RegWrEn) begin
      reg_blabla                             <= RegWrData[31:0];
    end else begin
      reg_blabla                             <= reg_blabla;
    end
  end

  assign REG4_reg_read = {          reg_blabla};

  //-----------------------
  assign swi_blabla = reg_blabla;



  
    
  //---------------------------
  // PRDATA Selection
  //---------------------------
  reg [31:0] prdata_sel;
  
  always @(*) begin
    case(RegAddr)
      'h0    : prdata_sel = REG1_reg_read;
      'h4    : prdata_sel = REG2_reg_read;
      'h8    : prdata_sel = REG3_reg_read;
      'hc    : prdata_sel = REG4_reg_read;

      default : prdata_sel = 32'd0;
    endcase
  end
  
  assign PRDATA = prdata_sel;


  
    
  //---------------------------
  // PSLVERR Detection
  //---------------------------
  reg pslverr_pre;
  
  always @(*) begin
    case(RegAddr)
      'h0    : pslverr_pre = 1'b0;
      'h4    : pslverr_pre = 1'b0;
      'h8    : pslverr_pre = 1'b0;
      'hc    : pslverr_pre = 1'b0;

      default : pslverr_pre = 1'b1;
    endcase
  end
  
  assign PSLVERR = pslverr_pre;

endmodule
