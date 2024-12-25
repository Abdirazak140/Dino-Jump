module ClockDividers(clk50MHz, clk25MHz, clk10Hz);
	input clk50MHz;
	output clk25MHz, clk10Hz;
	
	//Get 25MHz Main system clock
	
	//PLL clock_divider(clk50MHz, clk25MHz);
	//clockDivider25MHz mainClock(clk50MHz, clk25MHz);
	PLLClock mainClock(clk50MHz, clk25MHz);
	
	
	//Get 10Hz Score Counter Clock
	clockDivider10Hz scoreClock(clk50MHz, clk10Hz);
endmodule


module clockDivider25MHz(clkIn, clkOut25MHz);
	//Clock Input 50MHz
	input clkIn;
	//Clock Output 25MHz
	output reg clkOut25MHz = 1'b0;
	
	//Counter
	reg [1:0] c = 2'd0;
	
	//On posedge
	always @ (posedge clkIn) begin
		//If counter is less than 2
		if (c < 2'd2) begin
			//Increment Counter
			c <= c + 1;
		end
		//Counter = 2
		else begin
			//Reverse edge of clock (pos > neg, neg > pos)
			clkOut25MHz <= ~clkOut25MHz;
			//Reset c to 0
			c <= 0;
		end
	end
endmodule


module clockDivider10Hz(clkIn, clkOut10Hz);
	//Clock Input 50MHz
	input clkIn;
	//Clock Output 25MHz
	output reg clkOut10Hz = 1'b0;
	
	//Counter
	reg [28:0] c = 28'd0;
	
	//On posedge
	always @ (posedge clkIn) begin
		//If counter is less than 1,250,000
		//50,000,000 / (2 * 2 * 10) = 1,250,000 ticks of 25MHz clock
		if (c < 28'd1250000) begin
			//Increment Counter
			c <= c + 1;
		end
		//Counter = 1,250,000
		else begin
			//Reverse edge of clock (pos > neg, neg > pos)
			clkOut10Hz <= ~clkOut10Hz;
			//Reset c to 0
			c <= 0;
		end
	end
endmodule