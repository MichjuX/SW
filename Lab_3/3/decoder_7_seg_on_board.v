module decoder_7_seg_on_board(
	input [6:5] SW,
	output [6:0] HEX5);

	decoder_7_seg decoder(SW[6:5], HEX5[6:0]);
endmodule