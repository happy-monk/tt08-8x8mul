/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_8x8mul (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);
  
  wire cs = ~ui_in[0];
  wire rd = ~ui_in[1];
  wire wr_n = ui_in[2];
  wire wr = ~wr_n;
  wire addr = ui_in[7];
  
  reg [7:0] A;
  reg [7:0] B;
  
  wire [15:0] Mul = A*B;
  
  always @(posedge wr_n) begin
    if (cs && addr == 0) A = ui_in;
    if (cs && addr == 1) B = ui_in;
  end;

  assign uo_out  = Mul[15:8];
  assign uio_out = addr ? Mul[15:8] : Mul[7:0];
  assign uio_oe  = cs && rd;

  // List all unused inputs to prevent warnings
  wire _unused = &{ena, clk, rst_n, 1'b0};

endmodule