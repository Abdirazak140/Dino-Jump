module ScoreDisplay(digit0, digit1, digit2, digit3, digit4, digit5, hex0, hex1, hex2, hex3, hex4, hex5);
	
	//Binary String Input per digit
	input [3:0] digit0, digit1, digit2, digit3, digit4, digit5;
	
	//Hex Display Output
	output [7:0] hex0, hex1, hex2, hex3, hex4, hex5;
	
	//Use hexDisplay Module to link digits with displays
	hexDisplay hexDis0(digit0, hex0);
	hexDisplay hexDis1(digit1, hex1);
	hexDisplay hexDis2(digit2, hex2);
	hexDisplay hexDis3(digit3, hex3);
	hexDisplay hexDis4(digit4, hex4);
	hexDisplay hexDis5(digit5, hex5);
	
endmodule


//Hex Display Module
module hexDisplay(in, out);
	input [3:0] in;
	output [7:0] out;
	wire a, b, c, d;
	
	//Standard 4 bits of input
	assign a = in[3];
	assign b = in[2];
	assign c = in[1];
	assign d = in[0];
	
	assign out[0] = (d & ~a & ~b & ~c) | (b & ~a & ~c & ~d) | 
	(a & c & d & ~b) | (a & b & d & ~c);
	// (D~(ABC)) + (B~(ACD)) + (ACD~B) + (ABD~C)
	
	assign out[1] = (b & d & ~a & ~c) | (b & c & ~a & ~d) | 
	(a & c & d & ~b) | (a & b & ~c & ~d) | (a & b & c & ~d) | (a & b & c & d);
	// (BD~(AC)) + (BC~(AD)) + (ACD~(B)) + (AB~(CD)) + (ABC~(D)) + (ABCD)
	
	assign out[2] = (~a & ~b & c & ~d) | (a & b & ~c & ~d) | (a & b & c);
	// (C~(ABD) + (AB~(CD)) + (ABC~(D)) + (ABCD)
	
	assign out[3] = (d & ~a & ~b & ~c) | (b & ~a & ~c & ~d) |
	(b & c & d & ~a) | (a & c & ~b & ~d) | (a & b & c & d);
	// (D~(ABC)) + (B~(ACD)) + (BCD~(A)) + (AC~(BD)) + (ABCD)
	
	assign out[4] = (d & ~a & ~b & ~c) | (c & d & ~a & ~b) | 
	(b & ~a & ~c & ~d) | (b & d & ~a & ~c) | (b & c & d & ~a) | (a & d & ~b & ~c);
	// (D~(ABC) + (CD~(AB)) + (B~(ACD)) + (BD~(AC)) + (BCD~(A)) + (AD~(BC))
	
	assign out[5] = (d & ~a & ~b & ~c) | (c & ~a & ~b & ~d) | 
	(c & d & ~a & ~b) | (b & c & d & ~a) | (a & b & d & ~c);
	// (D~(ABC)) + (C~(ABD) + (CD~(AB)) + (BCD~(A)) + (ABD~(C))
	
	assign out[6] = (~a & ~b & ~c & ~d) | (d & ~a & ~b & ~c) | 
	(b & c & d & ~a) | (a & b & ~c & ~d);
	// (~(ABCD)) + (D~(ABC)) + (BCD~(A)) + (AB~(CD))
	
	assign out[7] = 1'b1;
	// Perma Off

endmodule

