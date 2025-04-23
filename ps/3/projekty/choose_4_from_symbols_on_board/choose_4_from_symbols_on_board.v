module choose_4_from_symbols_on_board(
	input [9:0] SW,
	output [9:0] LEDR,
	output [6:0] HEX0);

	assign LEDR = SW;
	wire [1:0] c;
	mux_4_1_2_bits mux(SW[7:6], SW[5:4], SW[3:2], SW[1:0], SW[9:8], c[1:0]);
	decoder_7_seg decoder(c[1:0], HEX0[6:0]);

endmodule

module mux_4_1_2_bits(
	input [1:0] u, v, w, x,
	input [1:0] s,
	output [1:0] m);

	mux_4_1_1_bit mux0(u[0], v[0], w[0], x[0], s[1:0], m[0]);
	mux_4_1_1_bit mux1(u[1], v[1], w[1], x[1], s[1:0], m[1]);

endmodule

module mux_4_1_1_bit(
	input u, v, w, x,
	input [1:0] s,
	output m);

	wire m_uv, m_wx;
	mux_2_1_1_bit mux_uv(u, v, s[0], m_uv);
	mux_2_1_1_bit mux_wx(w, x, s[0], m_wx);
	mux_2_1_1_bit mux_uvwx(m_uv, m_wx, s[1], m);

endmodule

module mux_2_1_1_bit(
	input x, y,
	s,
	output m);

	assign m = (~s & x) | (s & y);

endmodule

module decoder_7_seg(
	input [1:0] c,
	output [6:0] h);

	assign {h[6], h[3]} = {2{ 1'b0 }};
	assign {h[5], h[0]} = {2{ ~c[1] }};
	assign h[4] = c[1] & c[0];
	assign h[2] = c[1] & (~c[0]);
	assign h[1] = c[1] | (~c[0]);

endmodule
