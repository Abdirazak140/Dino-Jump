module RandomGenerator(clk, out);
	input clk;
	//output reg [7:0] out;
	output [7:0] out;
	reg [7:0] bits;
	
	assign feedback = {8{out[7]}};
	
	// LFSR implementation
	initial begin
      //out = 8'hc3;
		bits = 8'hc3;
	end
	
	always @ (posedge clk) begin
		//out <= {out[6:0], out[7] ^ out[5] ^ out[4] ^ out[3]};
		bits <= ((bits ^ feedback) << 1) | !bits[7];
	end
	
	assign out = bits;
endmodule

