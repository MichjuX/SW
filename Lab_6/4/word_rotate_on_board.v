module word_rotate_on_board(
	input CLOCK_50,
	output [6:0] HEX3, HEX2, HEX1, HEX0);

	wire [7:0] chars;
	word_rotate wr(CLOCK_50, chars[7:0]);
	decoder_7_seg dec3(chars[7:6], HEX3);
	decoder_7_seg dec2(chars[5:4], HEX2);
	decoder_7_seg dec1(chars[3:2], HEX1);
	decoder_7_seg dec0(chars[1:0], HEX0);

endmodule