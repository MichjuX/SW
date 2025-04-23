module buffered_multiplier_N_bits
	#(parameter N = 8)(
	input [N-1:0] Data,
	input clk, aclr, EA, EB,
	output [2*N-1:0] P,
	output [N-1:0] A_B);

	wire [N-1:0] A, B;
	register_N_bits_ena_aclr #(N) r_A(Data, clk, aclr, EA, A);
	register_N_bits_ena_aclr #(N) r_B(Data, clk, aclr, EB, B);
	mux_4_1 #(N) mux({N{1'b0}}, B, A, {N{1'b0}}, {EA, EB}, A_B);

	wire [2*N-1:0] mul_P;
	multiplier_N_bits #(N) mul(A, B, mul_P);
	register_N_bits_ena_aclr #(2*N) r_P(mul_P, clk, aclr, 1'b1, P);

endmodule







