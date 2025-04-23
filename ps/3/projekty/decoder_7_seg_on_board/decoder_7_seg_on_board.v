module decoder_7_seg_on_board(
	input [1:0] SW,
	output [6:0] HEX0);

	decoder_7_seg decoder(SW[1:0], HEX0[6:0]);

endmodule

module decoder_7_seg(
	input [1:0] c,
	output [6:0] h);

	assign {h[6], h[3]} = {2{ 1'b0 }};
	assign {h[5], h[0]} = {2{ ~c[1] }};
	assign h[4] = c[1] & c[0];
	assign h[2] = c[1] & (~c[0]);
	assign h[1] = c[1] | (~c[0]);

endmodule
