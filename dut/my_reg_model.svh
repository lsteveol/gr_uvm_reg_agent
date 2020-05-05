//===================================================================
//
// Created by sbridges on May/05/2020 at 07:27:18
//
// my_reg_addr_defines.vh
//
//===================================================================



`define MY_REG_REG1                                                            'h00000000
`define MY_REG_REG1__BF3                                                               11
`define MY_REG_REG1__BF2                                                             10:3
`define MY_REG_REG1__BF1                                                              2:0
`define MY_REG_REG1___POR                                                    32'h00000804

`define MY_REG_REG2                                                            'h00000004
`define MY_REG_REG2__BF5                                                            26:24
`define MY_REG_REG2__RESERVED0                                                      23:18
`define MY_REG_REG2__BF4                                                             17:0
`define MY_REG_REG2___POR                                                    32'h070004D2

`define MY_REG_REG3                                                            'h00000008
`define MY_REG_REG3__BF6                                                              3:0
`define MY_REG_REG3___POR                                                    32'h00000005

`define MY_REG_REG4                                                            'h0000000C
`define MY_REG_REG4__BLABLA                                                          31:0
`define MY_REG_REG4___POR                                                    32'h0001E240

