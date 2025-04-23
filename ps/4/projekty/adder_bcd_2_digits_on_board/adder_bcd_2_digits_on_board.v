module adder_bcd_2_digits_on_board(
	input [8:0] SW,
	output [6:0] HEX5, HEX3, HEX1, HEX0,
	output [9:0] LEDR);

	assign LEDR[8:0] = SW[8:0];
	decoder_hex_10 dec_x(SW[7:4], HEX5);
	decoder_hex_10 dec_y(SW[3:0], HEX3);
	wire [3:0] s1, s0;
	adder_bcd_2_digits adder(SW[7:4], SW[3:0], SW[8], s1, s0, LEDR[9]);
	decoder_hex_10 dec_s1(s1, HEX1);
	decoder_hex_10 dec_s0(s0, HEX0);

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

module adder_bcd_2_digits(
	input [3:0] x, y,
	input cin,
	output [3:0] s1, s0,
	output error);

	assign error = ((x > 4'd9) | (y > 4'd9)); // syntezuje 2 4-bitowe komparatory
	wire [4:0] binary_sum = {1'b0, x} + {1'b0, y} + {3'b0000, cin};
	binary_bcd_5_bits conv(binary_sum, s1, s0);

endmodule

module binary_bcd_5_bits(
	input [4:0] v,
	output [3:0] d1, d0);

	wire v_greater_than_9 = (v > 5'd9); // Comparator > 9
	/* odrzucamy najwyższy bit różnicy v - 10, bo przed odjęciem 10 suma może być równa
	max 19 (mieści się na 5 bitach), a po odjęciu max 9 (mieści się na 4 bitach) */
	wire [3:0] v_minus_10 = v - 5'd10; // Circuit A
	wire [3:0] lower_bcd_digit;
	mux_2_1_4_bits mux(v, v_minus_10, v_greater_than_9, lower_bcd_digit);

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
