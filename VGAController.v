module VGAController(clk, vsync, hsync, x, y);

	//Input 25MHz Clock
	input clk;
	//Output pulse
	output vsync, hsync;
	//Output Coordinate
	output reg[9:0] x, y;
	
	reg [9:0] xCounter, yCounter;
	
	//Horizontal Pixels
	//Back porch (left) = 48, Front porch (right) = 16, Sync Pulse = 96, Active Area = 640
	//Horizontal Counter = 640 + 48 + 16 + 96 = 800 Pixels
	//Bounds, 144 < x < 783
	
	//Horizontal Counter
	always @(posedge clk) begin
		//xCounter less than max length
		if (xCounter < 799) begin
			//Increment Counter
			xCounter <= xCounter + 1;
		end
		//xCounter = max distance (800)
		else begin
			//Reset Counter
			xCounter <= 0;
		end
	end
	
	//Vertical Pixels
	//Back porch = 33, Front porch = 10, Sync Pulse = 2, active area = 480
	//Vertical Counter = 480 + 33 + 10 + 2 = 525 Pixels
	//Bounds, 35 < y < 514
	
	//Verticle Counter
	always @(posedge clk) begin
		//Start counting when horizontal is finished
		if (xCounter == 799) begin
			//yCounter less than max height
			if (yCounter < 525) begin
				//Increment Counter
				yCounter <= yCounter + 1;
			end
			//yCounter = max height (525)
			else begin
				//Reset Counter
				yCounter <= 0;
			end
		end
	end
	
	//Set Positions
	always @(posedge clk) begin
		//Check if pixels exist within horizontal display bounds
		if (144 <= xCounter && xCounter < 784) begin
			//Calculate x of pixel within display bounds
			x = xCounter - 144;
		end
		//Pixel outside of display bounds
		else begin
			//Set to 0
			x = 0;
		end
		//Check if pixel exists within vertical display bounds
		if (35 <= yCounter && yCounter < 515) begin
			//Calculate y of pixel within display bounds
			y = yCounter - 35;
		end
		//Pixel outside of display bounds
		else begin
			//Set to 0
			y = 0;
		end
	end
	
	//Set hsync to high for first 96 ticks
	assign hsync = (xCounter >= 0 && xCounter < 96) ? 1:0;   
	//Set vsync to high for first 2 ticks	
	assign vsync = (yCounter >= 0 && yCounter < 2) ? 1:0;
	
endmodule