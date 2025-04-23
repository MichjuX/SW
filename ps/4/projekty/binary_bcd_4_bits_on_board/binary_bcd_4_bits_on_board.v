module binary_bcd_4_bits_on_board(
	input [3:0] SW,
	output [6:0] HEX1, HEX0);

	wire [3:0] d1, d0;
	binary_bcd_4_bits converter(SW, d1, d0);
	decoder_hex_10 dec_d1(d1, HEX1);
	decoder_hex_10 dec_d0(d0, HEX0);

endmodule

module decoder_hex_10(
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
			default: h = 7'b1111111; // 127
		endcase

endmodule

module binary_bcd_4_bits(
	input [3:0] v,
	output [3:0] d1, d0);

	wire v_greater_than_9 = (v > 4'd9); // Comparator > 9
	wire [3:0] v_minus_10 = v - 4'd10; // Circuit A
	wire [3:0] lower_bcd_digit;
	mux_2_1_4_bits mux(v, v_minus_10, v_greater_than_9, lower_bcd_digit);
	assign d1 = {3'b000, v_greater_than_9};
	assign d0 = lower_bcd_digit;

endmodule

module mux_2_1_4_bits(
	input [3:0] x, y,
	input s,
	output [3:0] m);

	mux_2_1_1_bit mux0(x[0], y[0], s, m[0]);
	mux_2_1_1_bit mux1(x[1], y[1], s, m[1]);
	mux_2_1_1_bit mux2(x[2], y[2], s, m[2]);
	mux_2_1_1_bit mux3(x[3], y[3], s, m[3]);

endmodule

module mux_2_1_1_bit(
	input x, y, s,
	output m);

	assign m = (~s & x) | (s & y);

endmodule
