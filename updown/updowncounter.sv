module updowncounter
  (
   input logic            clk,
   input logic            rst,
   input logic            up,
   output logic [3:0] count
   );

   // insert your code here
   always_ff @(posedge clk or posedge rst)
	   if(rst)
		   count <= 0;
	   else
		   if(up)
			   count <= count == 4'b1111 ? 4'b0000 : count + 1;
		   else
			   count <= count == 4'b0000 ? 4'b1111 :  count - 1;
endmodule
