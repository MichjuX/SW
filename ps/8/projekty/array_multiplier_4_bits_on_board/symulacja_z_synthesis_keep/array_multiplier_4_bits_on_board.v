module array_multiplier_4_bits_on_board(
	input [7:0] SW,
	output [6:0] HEX2, HEX0, HEX5, HEX4);

	wire [3:0] A = SW[7:4], B = SW[3:0];
	wire [7:0] P /* synthesis keep */;
	array_multiplier_4_bits mul(A, B, P);

	decoder_hex_16(A, HEX2);
	decoder_hex_16(B, HEX0);
	decoder_hex_16(P[7:4], HEX5);
	decoder_hex_16(P[3:0], HEX4);

endmodule

module decoder_hex_16(
	input [3:0] binary,
	output reg [6:0] h);

	always @ (*)
		case (binary)
			4'd0: h = 7'b1000000; // 64
			4'd1: h = 7'b1111001; // 121
			4'd2: h = 7'b0100100; // 36
			4'd3: h = 7'b0110000; // 48
			4'd4: h = 7'b0011001; // 25
			4'd5: h = 7'b0010010; // 18
			4'd6: h = 7'b0000010; // 2
			4'd7: h = 7'b1111000; // 120
			4'd8: h = 7'b0000000; // 0
			4'd9: h = 7'b0010000; // 16
			4'd10: h = 7'b0001000; // 8; A
			4'd11: h = 7'b0000011; // 3; b
			4'd12: h = 7'b0100111; // 39; c
			4'd13: h = 7'b0100001; // 33; d
			4'd14: h = 7'b0000110; // 6; E
			4'd15: h = 7'b0001110; // 14; F
		endcase

endmodule

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

module full_adder(
	input a, b, cin,
	output s, cout);

	assign s = cin ^ (a ^ b);
	assign cout = a & b | (a ^ b) & cin;

endmodule
