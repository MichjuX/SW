module slow_counter_mod_10_on_board(
	input CLOCK_50,
	output [6:0] HEX0);

	wire [3:0] Q;
	slow_counter_mod_10 slow_counter(CLOCK_50, Q);
	decoder_hex_10 decoder(Q, HEX0);

endmodule