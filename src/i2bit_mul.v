/*
2-bit UT Vedic multiplier
*/
module i2bit_mul (a0, a1, b0, b1, s0, s1, s2, s3);
	//input	[1:0]	a;
	//input	[1:0]	b;
	//output	[3:0]	s;
	input a0, a1, b0, b1;
	output s0, s1, s2, s3;
	
	assign s0	=	a0 & b0;
	assign s1	=	(a1 & b0) ^ (a0 & b1);
	assign s2	=	(a0 & b1 & a1 & b0) ^ (a1 & b1);
	assign s3	=	(a0 & a1 & b0 & b1);

endmodule
