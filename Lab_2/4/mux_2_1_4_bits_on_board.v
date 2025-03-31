module mux_2_1_4_bits_on_board(
	input [7:0] SW,
	input [0:0] KEY,
	output [3:0] LEDR);
	
	mux_2_1_4_bits mux4b(SW[3:0], SW[7:4], KEY[0], LEDR[3:0]);
endmodule
