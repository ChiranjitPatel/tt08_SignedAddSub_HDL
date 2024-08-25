//-----------------------------------------------------------------------------------------------------------------------------------------------------
// Company:			BHEL - Strukton - ARM - Embedded
// Engineer:		Vivek Adi, Chiranjit Patel (email: vivek.adishesha@gmail.com)
//
// Creation Date:	(c) 2022 BHEL Strukton ARM 
// Design Name:		Signed adder and subtractor testbench
// Module Name:		signed_addsub_tb - Behavioral
// Project Name:	Computational Core
// Target Devices:	Altera FPGA Cyclone II EP2C15AF484I8N / EP2C5T144C8N
// Tool Versions:	Quartus 13.1 sp1
// Description:		
// Dependencies:	sv_lib, signed_addsub_8
// Revision:		Revision 0.01 - File Created
// Comments:
//-----------------------------------------------------------------------------------------------------------------------------------------------------	

`timescale 1ns/1ns

module tt_um_signed_addsub_tb;
	parameter N = 8;
	logic	[N-1:0]	a;
    logic	[N-1:0]	b;
    logic	[1:0]	sign;
    logic	[N-1:0]	res_signed;
	
	tt_um_signed_addsub_8 dut (
							.a(a),
	                        .b(b),
	                        .sign(sign),
							.res_signed(res_signed)
	);
	
	task delay(int n);
		begin
			#(n);
		end
	endtask
	
	task init();
		begin
			a = 8'h00;
			b = 8'h00;
			sign = 2'h0;
		end
	endtask
	
	initial begin
		init();
		delay(300);
		
		// A+B
		sign = 2'h0;
		a = 8'hf2;
		b = 8'he7;
		delay(300);

		// A-B
		sign = 2'h1;
		a = 8'hf2;
		b = 8'he7;
		delay(300);
		
		// -A+B
		sign = 2'h2;
		a = 8'hf2;
		b = 8'he7;
		delay(300);
		
		// -A-B
		sign = 2'h3;
		a = 8'hf2;
		b = 8'he7;
		delay(300);
	
	end
endmodule
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		
		
		
