module binary_bcd_4_bits(
	input [3:0] v,
	output [3:0] d1, d0);

	wire v_greater_than_9 = (v > 4'd9); // Comparator > 9
	wire [3:0] v_minus_10 = v - 4'd10; // Circuit A
	wire [3:0] lower_bcd_digit;
	mux_2_1_4_bits mux(v, v_minus_10, v_greater_than_9, lower_bcd_digit);
	assign d1 = {3'b000, v_greater_than_9};
	assign d0 = lower_bcd_digit;

endmodule

module mux_2_1_4_bits(
	input [3:0] x, y,
	input s,
	output [3:0] m);

	mux_2_1_1_bit mux0(x[0], y[0], s, m[0]);
	mux_2_1_1_bit mux1(x[1], y[1], s, m[1]);
	mux_2_1_1_bit mux2(x[2], y[2], s, m[2]);
	mux_2_1_1_bit mux3(x[3], y[3], s, m[3]);

endmodule

module mux_2_1_1_bit(
	input x, y, s,
	output m);

	assign m = (~s & x) | (s & y);

endmodule
