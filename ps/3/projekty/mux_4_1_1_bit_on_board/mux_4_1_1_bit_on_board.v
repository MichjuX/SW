module mux_4_1_1_bit_on_board(
	input [3:0] SW,
	input [1:0] KEY,
	output [0:0] LEDR);
	
	mux_4_1_1_bit mux(SW[0], SW[1], SW[2], SW[3], KEY[1:0], LEDR[0]);
	
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
