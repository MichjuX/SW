module mux_4_1_2_bits(
	input [1:0] u, v, w, x,
	input [1:0] s,
	output [1:0] m);
	
	mux_4_1_1_bit mux0(u[0], v[0], w[0], x[0], s[1:0], m[0]);
	mux_4_1_1_bit mux1(u[1], v[1], w[1], x[1], s[1:0], m[1]);
endmodule
