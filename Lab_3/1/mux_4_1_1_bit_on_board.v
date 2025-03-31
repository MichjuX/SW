module mux_4_1_1_bit_on_board(
	input [3:0] SW,
	input [1:0] KEY,
	output [0:0] LEDR);
	
	mux_4_1_1_bit mux(SW[0], SW[1], SW[2], SW[3], KEY[1:0], LEDR[0]);
endmodule
