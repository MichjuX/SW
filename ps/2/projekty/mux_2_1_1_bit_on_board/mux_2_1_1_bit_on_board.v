module mux_2_1_1_bit_on_board(
	input [1:0] SW,
	input [0:0] KEY,
	output [0:0] LEDR);

	mux_2_1_1_bit mux0(SW[0], SW[1], KEY[0], LEDR[0]);

endmodule

module mux_2_1_1_bit(
	input x, y, s,
	output m);

	assign m = (~s & x) | (s & y);

endmodule
