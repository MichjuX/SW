module array_multiplier_4_bits_on_board(
	input [7:0] SW,
	output [6:0] HEX2, HEX0, HEX5, HEX4);

	wire [3:0] A = SW[7:4], B = SW[3:0];
	wire [7:0] P;
	array_multiplier_4_bits mul(A, B, P);

	decoder_hex_16(A, HEX2);
	decoder_hex_16(B, HEX0);
	decoder_hex_16(P[7:4], HEX5);
	decoder_hex_16(P[3:0], HEX4);

endmodule






