module ScoreCounter(clk, reset, state, digit5, digit4, digit3, digit2, digit1, digit0);

	//10Hz Clock and Reset Button and Freeze Counter State inputs
	input clk, reset, state;
	
	//Binary Representation of Decimal Counter Output
	output [3:0] digit5, digit4, digit3, digit2, digit1, digit0;
	
	//Initialize Carry Bits
	wire carry0, carry1, carry2, carry3, carry4, carry5;
	
	//Ripple Counter Stack
	//First Counter goes based on 10Hz Clock
	//All sequential counters trigger when the preceding counter hits 10 (carry = 1)
	//Digits are named based on hex display, digit0 = ones, digit5 = hundred thousands
	//When state is active, all counters freeze
	decimalCounter dig0(clk, reset, state, digit0, carry0);
	decimalCounter dig1(carry0, reset, state, digit1, carry1);
	decimalCounter dig2(carry1, reset, state, digit2, carry2);
	decimalCounter dig3(carry2, reset, state, digit3, carry3);
	decimalCounter dig4(carry3, reset, state, digit4, carry4);
	decimalCounter dig5(carry4, reset, state, digit5, carry5);

endmodule

module decimalCounter(tick, reset, state, counter, carry);
	//Input for activation, reset and pause
	input tick, reset, state;
	
	//Output for Carry bit
	output reg carry = 1'b0;
	//Output for binary string representation of count
	output reg [3:0] counter = 4'b0000;
	
	//Activate whenever tick triggers posedge
	always @ (posedge tick) begin
		//Reset
		if (~reset) begin
			carry <= 1'b1; //Trigger sequential counters
			counter <= 4'b0000; //Set Counter to 0
		end
		
		//State = Alive = 0 = Count
		//State = Dead = 1 = Freeze
		else if (~state) begin
			//Counter = 9
			if (counter == 4'b1001) begin
				carry <= 1'b1; //Set carry to ON
				counter <= 4'b0000; //Set counter to 0
			end
			
			//Counter < 9
			else begin
				counter <= counter + 1; //Increment Counter
				
				//If carry is ON
				if (carry == 1'b1) begin
					carry <= 1'b0; //Set carry to OFF
				end
			end
		end
		//If carry is ON
		if (carry == 1'b1) begin
			carry <= 1'b0; //Set carry to OFF
		end
	end
endmodule

