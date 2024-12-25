module Engine(jumpButton, resetButton, clk, clk25MHz, state, dinoX, dinoY, obsX, obsY);
	input jumpButton, resetButton, clk, clk25MHz;
	output reg state;
	wire [11:0] dinoX, dinoY, obsX, obsY;
	output dinoX, dinoY;
	output obsX, obsY;
	
	//Default Dino Position
	//X = 50
	//Y = 480-20 == 460 (Floor)

	//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	//Jump
	//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	//Can only be used while dino is on the ground
	//Works on button release to prevent bunny hopping
	//Initial Velocity = 32 pixels / tick
	//Bit Shift Register to ditermine current velocity
	wire [11:0] dinoPosX, dinoPosY;
	dinoPhysics dino(jumpButton, clk, state, dinoPosX, dinoPosY);
	assign dinoX = dinoPosX;
	assign dinoY = dinoPosY;
	
	
	//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	//Objects
	//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	wire [11:0] obsPosX, obsPosY;
	wire [7:0] randomSpawn;
	RandomGenerator random1(clk25MHz, randomSpawn);
	
	wire [7:0] randomHeight;
	RandomGenerator random2(clk25MHz, randomHeight);
	
	obstacleMovement obs(clk, randomSpawn, randomHeight, 11, state, 0, obsPosX, obsPosY);
	assign obsX = obsPosX;
	assign obsY = obsPosY;
	//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	//Collision Detection
	//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	collisionDetection col(clk, resetButton, dinoX, dinoY, obsX, obsY, flag);
	
	
	
	
	
	//Update game events in sync with game clock (10Hz)
	always @(posedge clk) begin
	
		//Reset button is pressed
		if (~resetButton) begin
			state <= 0;
		end
		
		//Reset button is not pressed
		else begin
		
			//Game is Active
			if (state == 0) begin
			
				
			
				//Collision Detected
				if (flag) begin
					//Set state to 1 (game over)
					state <= 1;
					$display("%b", state); 
				end
				
			end
		end
		
	end
	
endmodule


module dinoPhysics(jumpButton, clk, state, positionX, positionY);
	input jumpButton, clk, state;

	//Base velocity while on floor = 0
	reg [6:0] velocity = 7'b000000;
	reg [6:0] gravity = 7'b000000;

	output reg [11:0] positionX = 11'd050;
	output reg [11:0] positionY = 11'd460;

	always @(posedge clk) begin

		//if (~jumpButton) begin
		// positionY <= positionY - 2'd10;
		//end
		//If game is active
		if (state == 0) begin
		//Jump is pressed and dino on floor
			if (~jumpButton && positionY >= 11'd450) begin
			//Jump (set velocity to 32 pixels)
				velocity <= 7'b1000000;
				gravity <= 7'b0000001;
			end
		//Dino has velocity
			else if (velocity > 0) begin
			//Move Dino Upwards by velocity amount
				positionY <= positionY - velocity;
			//Decrease Velocity by factor of 2
				velocity <= velocity >> 1;
			end
			//Dino has no velocity but has gravity
			else if (velocity == 0) begin
			//Move Dino Downwards by gravity amount
				positionY <= positionY + gravity;
			//Decrease Gravity by factor of 2
				gravity <= gravity << 1;
			end
		end
		//Game is inactive
		else begin
		//Reset Y position
			velocity <= 0;
			gravity <= 0;
			positionY <= 11'd460;
		end
	end
endmodule


module collisionDetection(clk, reset, dinoX, dinoY, objectX, objectY, flag);
	input clk, reset;
	input [11:0] dinoX, dinoY, objectX, objectY;
	output reg flag;
	
	initial begin
		flag = 0;
	end
	
	always @(posedge clk) begin
		//Reset
		if (~reset) begin
			//Reset Flag
			flag <= 0;
		end
		//Detect Collision
		else if (60 >= objectX && objectX >= dinoX && dinoY >= objectY) begin
			//Trigger Flag
			flag <= 1;
		end
	end
endmodule


module obstacleMovement(clk, randomSpawn, randomHeight, velocity, state, delay, obsX, obsY);
	input clk, state;
	input [3:0] velocity;
	input [7:0] randomSpawn, randomHeight;
	input [4:0] delay;
	output reg [11:0] obsX, obsY;
	
	reg active;
	reg [4:0] objectDelay;
	reg [7:0] lastHeight;
	
	initial begin
		obsY = 459-80;
		active = 0;
		objectDelay = 0;
		lastHeight = 0;
	end
	
	always @(posedge clk) begin
		//If object exists
		if (~state) begin
			if (active) begin
				//Move object to the right 11 pixels per tick
				obsX <= obsX - velocity;
				//If object has reached end of screen
				if ((obsX+20) < 1) begin
					//Remove object
					active <= 0;
				end
			end
			//Object does not exist
			else if (~active) begin
				//Delay is over and a high chance an obstacle will spawn
				if (objectDelay == 0) begin
					//Create new object
					obsX <= 650;
					if (randomHeight != lastHeight) begin
						obsY <= 459 - ((randomHeight % 121) + 10);
						lastHeight <= randomHeight;
					end
					active <= 1;
					//Load new Delay
					objectDelay <= delay;
				end
				
				//Delay is not over
				else if (objectDelay > 0) begin
					//Reduce delay
					objectDelay <= objectDelay - 1;
				end
				
			end
		end
		else begin
			//Reset 
			obsX <= 650;
			if (randomHeight != lastHeight) begin
				obsY <= 459 - ((randomHeight % 121) + 10);
				lastHeight <= randomHeight;
			end
			active <= 0;
			objectDelay <= delay;
		end
	end
	
endmodule
