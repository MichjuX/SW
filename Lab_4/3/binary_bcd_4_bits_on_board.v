module binary_bcd_4_bits_on_board(
	input [3:0] SW,
	output [6:0] HEX1, HEX0);

	wire [3:0] d1, d0;

	wire v_greater_than_9;
	comparator comp(SW, 4'd9, v_greater_than_9);

	wire [3:0] v_minus_10;
	sumator sub(SW, 4'b1010, v_minus_10); // 4'b1010 = 10 w dec

	wire [3:0] lower_bcd_digit;
	mux_2_1_4_bits mux(SW, v_minus_10, v_greater_than_9, lower_bcd_digit);
	assign d1 = {3'b000, v_greater_than_9};
	assign d0 = lower_bcd_digit;

	decoder_hex_10 dec_d1(d1, HEX1);
	decoder_hex_10 dec_d0(d0, HEX0);

endmodule