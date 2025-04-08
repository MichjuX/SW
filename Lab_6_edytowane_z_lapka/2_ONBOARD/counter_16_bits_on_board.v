module counter_16_bits_on_board(
	input CLOCK_50,
	input [0:0] KEY,
	output [6:0] HEX3, HEX2, HEX1, HEX0);

	wire [15:0] q;
	counter_16_bits counter(CLOCK_50, KEY[0], 1'b1, q);
	decoder_hex_16 dec3(q[15:12], HEX3);
	decoder_hex_16 dec2(q[11:8], HEX2);
	decoder_hex_16 dec1(q[7:4], HEX1);
	decoder_hex_16 dec0(q[3:0], HEX0);

endmodule