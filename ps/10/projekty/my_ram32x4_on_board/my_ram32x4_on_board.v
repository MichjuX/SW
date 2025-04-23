module my_ram32x4_on_board(
	input [9:0] SW,
	input [0:0] KEY,
	output [6:0] HEX5, HEX4, HEX2, HEX0);

	// usunąć synthesis keep przed kompilacją na płytę
	wire [3:0] q /* synthesis keep */;
	ram32x4 ram(SW[8:4], KEY[0], SW[3:0], SW[9], q);
	decoder_hex_16 dec_address1({3'b000, SW[8]}, HEX5);
	decoder_hex_16 dec_address0(SW[7:4], HEX4);
	decoder_hex_16 dec_data(SW[3:0], HEX2);
	decoder_hex_16 dec_q(q, HEX0);

endmodule

module decoder_hex_16(
	input [3:0] binary,
	output reg [6:0] h);

	always @ (*)
		case (binary)
			4'd0: h = 7'b1000000; // 64
			4'd1: h = 7'b1111001; // 121
			4'd2: h = 7'b0100100; // 36
			4'd3: h = 7'b0110000; // 48
			4'd4: h = 7'b0011001; // 25
			4'd5: h = 7'b0010010; // 18
			4'd6: h = 7'b0000010; // 2
			4'd7: h = 7'b1111000; // 120
			4'd8: h = 7'b0000000; // 0
			4'd9: h = 7'b0010000; // 16
			4'd10: h = 7'b0001000; // 8; A
			4'd11: h = 7'b0000011; // 3; b
			4'd12: h = 7'b0100111; // 39; c
			4'd13: h = 7'b0100001; // 33; d
			4'd14: h = 7'b0000110; // 6; E
			4'd15: h = 7'b0001110; // 14; F
		endcase

endmodule
