module twotrafficlights(
      input  logic clk,
      input  logic rst,
      output logic [2:0] lightsA, 
      output logic [2:0] lightsB
    );
  	logic [2:0] state, next_state;
	logic b_active;
  	// insert your code here
	always_comb begin 
		next_state[0] = state[2] & state[1];
		next_state[1] = ~state[1];
		next_state[2] = state[2] ^ state[1];
	end
  
	always_ff @(posedge clk or posedge rst) begin
		if(rst) begin
			state <= 3'b110;
			b_active <= 1'b1;
			lightsA <= 3'b100;
       			lightsB <= 3'b110;			
		end else begin
			state <= next_state;

			if (next_state == 3'b100)
				b_active <= ~b_active;

			if (b_active) begin
				lightsA <= 3'b100;
				lightsB <= next_state;
			end else begin
				lightsA <= next_state;
				lightsB <= 3'b100;
			end
		end
	end
endmodule
