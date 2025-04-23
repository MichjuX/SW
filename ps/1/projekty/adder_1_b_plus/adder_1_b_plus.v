module adder_1_b_plus(
	input cin, a, b,
	output cout, s);

	assign {cout, s} = cin + a + b;

endmodule
