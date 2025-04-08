module counter_16_bits(
	input clk, areset, enable,
	output reg [15:0] Q);

	always @ (posedge clk, negedge areset)
		if (!areset) Q <= {16{1'b0}};
		else if (enable) Q <= Q + 1'b1;
		else Q <= Q;

endmodule
