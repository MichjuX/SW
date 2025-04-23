module bcd_2_digit(
	input [7:0] SW,
	output [9:0] LEDR,
	output [6:0] HEX1, HEX0);

	assign LEDR[7:0] = SW[7:0];
	decoder_hex_10 dec1(SW[7:4], HEX1[6:0]);
	bcd_validator val1(SW[7:4], LEDR[9]);
	decoder_hex_10 dec0(SW[3:0], HEX0[6:0]);
	bcd_validator val0(SW[3:0], LEDR[8]);

endmodule

module decoder_hex_10(
	input [3:0] x,
	output reg [6:0] h);

	always @ (*)
		case (x)
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
			default: h = 7'b1111111; // 127
		endcase

endmodule

module bcd_validator(
	input [3:0] x,
	output reg error);

	always @ (*)
		case (x)
			4'd10, 4'd11, 4'd12, 4'd13, 4'd14, 4'd15: error = 1'b1;
			default: error = 1'b0;
		endcase

endmodule
