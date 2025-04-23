module array_multiplier_4_bits(
	input [3:0] A, B,
	output [7:0] P);

	wire ab[3:0][3:0]; // 1-bitowe iloczyny a*b
	generate
		genvar ai, bi;
		for (ai = 0; ai <= 3; ai = ai + 1) begin: fora
			for (bi = 0; bi <= 3; bi = bi + 1) begin: forb
				assign ab[ai][bi] = A[ai] & B[bi];
			end
		end
	endgenerate

	wire s[11:0], cout[11:0]; // 1-bitowe sumy i przeniesienia z pełnych sumatorów
	full_adder fa0(ab[1][0], ab[0][1], 1'b0, s[0], cout[0]);
	full_adder fa1(ab[2][0], ab[1][1], cout[0], s[1], cout[1]);
	full_adder fa2(ab[3][0], ab[2][1], cout[1], s[2], cout[2]);
	full_adder fa3(1'b0, ab[3][1], cout[2], s[3], cout[3]);
	full_adder fa4(s[1], ab[0][2], 1'b0, s[4], cout[4]);
	full_adder fa5(s[2], ab[1][2], cout[4], s[5], cout[5]);
	full_adder fa6(s[3], ab[2][2], cout[5], s[6], cout[6]);
	full_adder fa7(cout[3], ab[3][2], cout[6], s[7], cout[7]);
	full_adder fa8(s[5], ab[0][3], 1'b0, s[8], cout[8]);
	full_adder fa9(s[6], ab[1][3], cout[8], s[9], cout[9]);
	full_adder fa10(s[7], ab[2][3], cout[9], s[10], cout[10]);
	full_adder fa11(cout[7], ab[3][3], cout[10], s[11], cout[11]);

	assign P = { cout[11], s[11], s[10], s[9], s[8], s[4], s[0], ab[0][0] };

endmodule