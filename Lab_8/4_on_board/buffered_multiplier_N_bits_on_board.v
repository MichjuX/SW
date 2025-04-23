module buffered_multiplier_N_bits_on_board(
	input [9:0] SW,
	input [1:0] KEY,
	output [6:0] HEX3, HEX2, HEX1, HEX0,
	output [7:0] LEDR);

	wire [15:0] P;
	buffered_multiplier_N_bits #(8) buf_mul(SW[7:0], ~KEY[1], ~KEY[0], SW[9], SW[8], P, LEDR);

	decoder_hex_16 dec3(P[15:12], HEX3);
	decoder_hex_16 dec2(P[11:8], HEX2);
	decoder_hex_16 dec1(P[7:4], HEX1);
	decoder_hex_16 dec0(P[3:0], HEX0);

endmodule












