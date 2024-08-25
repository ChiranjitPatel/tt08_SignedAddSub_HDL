/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_sign_addsub (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  // All output pins must be assigned. If not used, assign to 0.
 // assign uo_out  = ui_in + uio_in;  // Example: ou_out is the sum of ui_in and uio_in
  signed_addsub_8 mul2bit (	.a(ui_in[1:0]),
		     		.b(ui_in[1:0]), 
		     		.res_sign(uo_out[1:0]),
				.sign(uio_out[0]));

  assign uo_out[7:2] = 6'b000000;
  assign uio_in = 0;
  assign uio_out[7:1] = 7'b0000000;
  assign uio_oe  = 0;

  // List all unused inputs to prevent warnings
  wire _unused = &{ena, clk, rst_n, 1'b0};

endmodule

//-----------------------------------------------------------------------------------------------------------------------------------------------------	

module signed_addsub_8 #(N = 2) (a, b, sign, res_signed);
	input 	logic	[N-1:0]	a;
	input 	logic	[N-1:0]	b;
	input 	logic	[1:0]	sign;
	output 	logic	[N-1:0]	res_signed;
	
	logic 	[N-1:0]	xin, yin, ha_wire_carry, ha_wire_sum;
	logic	[N-2:0] fa_wire_cin;
	logic 	[1:0]	carry_sign;
		
	genvar i;
	generate
		for (i = 0; i < N; i++) begin : xor_and_result_loop
			// Input 2'C
			assign xin[i] = sign[1] ? a[i] ^ 1'b1 : a[i];
			assign yin[i] = sign[0] ? b[i] ^ 1'b1 : b[i];
		end
		
		for (i = 0; i < N-1; i++) begin : ha_in_loop
			// Half Adder 
			ha ha_input (.a(xin[i]), .b(yin[i]), .cout(ha_wire_carry[i]), .sout(ha_wire_sum[i]));
		end
		
		// Add +1 for 2'C + two sign bits for ++, +-, -+, --
		fa fa_2c (.a(ha_wire_sum[0]), .b(sign[0]), .c(sign[1]), .cout(fa_wire_cin[0]), .sout(res_signed[0]));
		
		for (i = 0; i < N-2; i++) begin : fa_in_loop
			// Full Adder
			fa fa_output (.a(ha_wire_carry[i]), .b(ha_wire_sum[i+1]), .c(fa_wire_cin[i]), .cout(fa_wire_cin[i+1]), .sout(res_signed[i+1]));
		end
		
		// Last Stage XOR
		xor xor_input 		(ha_wire_carry[N-1], xin[N-1], yin[N-1]);
		xor xor_fa_add 		(ha_wire_sum[N-1], ha_wire_carry[N-1], ha_wire_carry[N-2]);
		xor xor_fa_add_2 	(res_signed[N-1], ha_wire_sum[N-1], fa_wire_cin[N-2]);
	endgenerate
endmodule
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
