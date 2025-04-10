module counter_BCD_3_digits_on_board(
	input CLOCK_50,
	input [0:0] KEY,
	output [6:0] HEX2, HEX1, HEX0,
	output [0:0] LEDR);

	wire [11:0] bcd /* synthesis keep */;
	counter_BCD_3_digits counter(CLOCK_50, KEY[0], bcd, LEDR[0]);
	decoder_hex_10 dec0(bcd[3:0], HEX0);
	decoder_hex_10 dec1(bcd[7:4], HEX1);
	decoder_hex_10 dec2(bcd[11:8], HEX2);

endmodule







