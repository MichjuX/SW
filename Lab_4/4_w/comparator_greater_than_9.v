module comparator_greater_than_9(
	input [3:0] V,
	output reg z);
	
	always @(*) begin
		if(V > 4'd9)
			z = 1'b1;
		else
			z = 1'b0;
	end
	
endmodule
