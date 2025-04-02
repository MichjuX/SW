module counter_T_4_bits(
	input clk, areset, enable,
	output [3:0] Q);

	wire [2:0] c;
	assign c[0] = Q[0] & enable;
	assign c[1] = Q[1] & c[0];
	assign c[2] = Q[2] & c[1];
	FFT_areset fft0(enable, clk, areset, Q[0]);
	FFT_areset fft1(c[0], clk, areset, Q[1]);
	FFT_areset fft2(c[1], clk, areset, Q[2]);
	FFT_areset fft3(c[2], clk, areset, Q[3]);

endmodule