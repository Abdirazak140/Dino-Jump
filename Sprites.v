module Sprites(state, x, y, clk, red, green, blue, dinoX, dinoY, obsX, obsY);
	input clk, state;
	input [9:0] x, y;
	input [11:0] dinoX, dinoY, obsX, obsY;
	output reg [3:0] red, green, blue;
	
	wire [3:0] floorRed, floorBlue, floorGreen;
	Floor drawFloor(1, floorRed, floorGreen, floorBlue);
	
	wire [3:0] dinoRed, dinoBlue, dinoGreen;
	Dino drawDino(1, dinoRed, dinoGreen, dinoBlue);
	
	wire [3:0] obsRed, obsBlue, obsGreen;
	Cactus drawCactus(1, obsRed, obsGreen, obsBlue);
	
	wire [3:0] deathScreenRed, deathScreenBlue, deathScreenGreen;
	DeathScreen ded(1, deathScreenRed, deathScreenGreen, deathScreenBlue);
	
	always @(x||y) begin
		//First D
		if (((170 <= x && x < 190 && 80 <= y && y < 180) || (190 <= x && x < 230 && 80 <= y && y < 100) || 
			(190 <= x && x < 230 && 160 <= y && y < 180) ||
			(230 <= x && x < 240 && 80 <= y && y < 180) ||
			(240 <= x && x < 250 && 90 <= y && y < 170)) && state == 1) begin
				red <= deathScreenRed;
				green <= deathScreenGreen;
				blue <= deathScreenBlue;
		end
			
		//E
		else if (((290 <= x && x < 310 && 80 <= y && y < 180) ||
			(310 <= x && x < 370 && 80 <= y && y < 100) ||
			(310 <= x && x < 360 && 120 <= y && y < 140) ||
			(310 <= x && x < 370 && 160 <= y && y < 180)) && state == 1) begin 
				red <= deathScreenRed;
				green <= deathScreenGreen;
				blue <= deathScreenBlue;
		end
			
		//Second D
		else if (((410 <= x && x < 430 && 80 <= y && y < 180) ||
			(430 <= x && x < 470 && 80 <= y && y < 100) ||
			(430 <= x && x < 470 && 160 <= y && y < 180) ||
			(470 <= x && x < 480 && 80 <= y && y < 180) ||
			(480 <= x && x < 490 && 90 <= y && y < 170)) && state == 1) begin
				red <= deathScreenRed;
				green <= deathScreenGreen;
				blue <= deathScreenBlue;
		end
		//Floor
		else if (y >= 460) begin
			red <= floorRed;
			green <= floorGreen;
			blue <= floorBlue;
		end
		//Dino
		else if (
		dinoX < x && 
		x < 60 && 
		dinoY > y && 
		y > (dinoY - 30)
		) begin
			  red <= dinoRed;
			  green <= dinoGreen;
			  blue <= dinoBlue;
		end
		//Obstacle
		else if (obsX < x && x < (obsX + 15) && obsY < y && y < 459) begin
			if ((y % 2) == 0 && (x < (obsX + 3) || x > (obsX + 11))) begin
				red <= 0;
				green <= 0;
				blue <= 0;
			end
			else begin
				red <= obsRed;
				green <= obsGreen;
				blue <= obsBlue;
			end
		end
		else begin
			red <= 0;
			green <= 0;
			blue <= 0;
		end
	end

endmodule

module Dino(enable, red, green, blue);

	input enable;
	output [3:0] red, green, blue;
	
	assign red = (enable) ? 0 : 0;
	assign green = (enable) ? 4'hF : 0;
	assign blue = (enable) ? 0 : 0;

endmodule

module Cactus(enable, red, green, blue);

	input enable;
	output [3:0] red, green, blue;
	
	assign red = (enable) ? 0 : 0;
	assign green = (enable) ? 4'h4 : 0;
	assign blue = (enable) ? 0 : 0;
	
endmodule

module Floor(enable, red, green, blue);

	input enable;
	output [3:0] red, green, blue;
	
	assign red = (enable) ? 4'hF : 0;
	assign green = (enable) ? 4'hA : 0;
	assign blue = (enable) ? 0 : 0;

endmodule

module DeathScreen(enable, red, green, blue);

	input enable;
	output [3:0] red, green, blue;
	
	assign red = (enable) ? 4'hFF : 0;
	assign green = (enable) ? 0 : 0;
	assign blue = (enable) ? 0 : 0;

endmodule

