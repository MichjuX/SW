module mux_2_1_1_bit_or_board(
	input [9:8] SW,
	input [0:0] KEY,
	output [0:0] LEDR);
	
	mux_2_1_1_bit(SW[8], SW[9], KEY[0], LEDR[0]);
endmodule
