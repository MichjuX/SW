module adder_1_b_assign(
	input cin, a, b,
	output cout, s);

	assign s = cin ^ (a ^ b);
	assign cout = a & b | (a ^ b) & cin;

endmodule
