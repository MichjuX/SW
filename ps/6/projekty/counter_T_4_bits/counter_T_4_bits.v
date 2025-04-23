/* module counter_T_4_bits_on_board(
	input [0:0] KEY,
	input [1:0] SW,
	output [6:0] HEX0);

	wire [3:0] q;
	counter_T_4_bits counter(KEY[0], SW[0], SW[1], q);
	decoder_hex_16 decoder(q, HEX0);

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

endmodule */

module counter_T_4_bits(
	input clk, areset, enable,
	output [3:0] Q);

	wire [2:0] c;
	assign c[0] = Q[0] & enable;
	assign c[1] = Q[1] & c[0];
	assign c[2] = Q[2] & c[1];
	FFT_areset fft0(enable, clk, areset, Q[0]);
	FFT_areset fft1(c[0], clk, areset, Q[1]);
	FFT_areset fft2(c[1], clk, areset, Q[2]);
	FFT_areset fft3(c[2], clk, areset, Q[3]);

endmodule

module FFT_areset(
	input T, clk, aclr,
	output reg Q);

	always @ (posedge clk, negedge aclr)
		if (!aclr) Q <= 1'b0;
		else if (T) Q <= ~Q;
		else Q <= Q;

endmodule
