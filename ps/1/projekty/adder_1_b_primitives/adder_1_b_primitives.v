module adder_1_b_primitives(
	input cin, a, b,
	output cout, s);

	wire a_xor_b;
	xor(a_xor_b, a, b);
	xor(s, cin, a_xor_b);

	wire a_and_b, a_xor_b_and_cin;
	and(a_and_b, a, b);
	and(a_xor_b_and_cin, a_xor_b, cin);
	or(cout, a_and_b, a_xor_b_and_cin);

endmodule
