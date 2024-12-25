module Project(clk50MHz,
KEY, 
HEX5, HEX4, HEX3, HEX2, HEX1, HEX0,
VGARed, VGAGreen, VGABlue,
VGAHSync, VGAVSync, SW);

	//Clock Input (Golden Top)
	input clk50MHz;
	
	//Game Clocks
	wire clk25MHz, clk10Hz, clk10HzBuffered, clk25HzBuffered;
	ClockDividers getClocks(clk50MHz, clk25MHz, clk10Hz);
	
	
	input SW;
	wire pauseSwitch;
	assign pauseSwitch = SW;
	//DLatch clockPause(clk50MHz, pauseSwitch, clk10Hz, clk10HzBuffered);
	assign clk10HzBuffered = (~pauseSwitch && clk10Hz);
	assign clk25HzBuffered = (~pauseSwitch && clk25MHz);
	
	//Button Inputs (Golden Top)
	input [1:0] KEY;
	//Assign Keys
	wire jumpKey, resetKey;
	assign jumpKey = KEY[0];
	assign resetKey = KEY[1];
	
	
	//Engine
	wire [11:0] dinoX, dinoY, obsX, obsY;
	wire state;
	Engine engine(jumpKey, resetKey, clk10HzBuffered, clk25HzBuffered, state, dinoX, dinoY, obsX, obsY);
	
	
	
	//HEX Display Output (Golden Top)
	output [7:0] HEX5, HEX4, HEX3, HEX2, HEX1, HEX0;
	
	//Score Counter
	wire [3:0] scoreDigit0, scoreDigit1, scoreDigit2, scoreDigit3, scoreDigit4, scoreDigit5;
	ScoreCounter scoreCount(clk10HzBuffered, resetKey, state, scoreDigit5, scoreDigit4, scoreDigit3, scoreDigit2, scoreDigit1, scoreDigit0);
	
	//Feed scores into display bank
	ScoreDisplay displayHex(scoreDigit0, scoreDigit1, scoreDigit2, scoreDigit3, scoreDigit4, scoreDigit5, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);

	//VGA Display
	output reg [3:0] VGARed;
	output reg [3:0] VGAGreen;
	output reg [3:0] VGABlue;
	output VGAHSync, VGAVSync;
	wire [9:0] x;
	wire [9:0] y;
	wire [3:0] red, green, blue;

	VGAController VGA(clk25MHz, VGAVSync, VGAHSync, x, y);
	Sprites spriteLoader(state, x, y, clk25MHz, red, green, blue, dinoX, dinoY, obsX, obsY);
	
	always @(posedge clk25MHz) begin
	
		VGARed <= red;
		VGAGreen <= green;
		VGABlue <= blue;
	end
	
endmodule
	


//Sources
//https://habr.com/en/articles/707224/
//https://github.com/nai1ka/MonitorTester_FPGA
//https://www.ece.ucdavis.edu/~bbaas/180/tutorials/vga/
//https://www.manualslib.com/manual/1429115/Terasic-De10-Lite.html?page=36#manual
//https://en.wikipedia.org/wiki/Linear-feedback_shift_register
