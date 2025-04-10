module real_time_clock_on_board(
	input CLOCK_50,
	input [7:0] SW,
	input [3:0] KEY,
	output [6:0] HEX5, HEX4, HEX3, HEX2, HEX1, HEX0);

	wire [7:0] m, s, cs;
	real_time_clock rtc(CLOCK_50, ~KEY[0], ~KEY[3], ~KEY[2], ~KEY[1], SW, m, s, cs);

	decoder_hex_10 d0(cs[3:0], HEX0);
	decoder_hex_10 d1(cs[7:4], HEX1);
	decoder_hex_10 d2(s[3:0], HEX2);
	decoder_hex_10 d3(s[7:4], HEX3);
	decoder_hex_10 d4(m[3:0], HEX4);
	decoder_hex_10 d5(m[7:4], HEX5);

endmodule
