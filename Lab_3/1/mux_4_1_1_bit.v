module mux_4_1_1_bit(
	input u, v, w, x,
	input [1:0] s,
	output m);
	
	wire m_uv, m_wx;
	
	mux_2_1_1_bit mux_uv(u, v, s[0], m_uv);
	mux_2_1_1_bit mux_wx(w, x, s[0], m_wx);
	mux_2_1_1_bit mux_uvWX(m_uv, m_wx, s[1], m);
	
endmodule
	
	