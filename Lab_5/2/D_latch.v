module D_latch(
	input D, Clk,
	output reg Q,
	output nQ
);

	always @ (D, Clk)
		if (Clk) Q = D;

	assign nQ = ~Q;

endmodule
