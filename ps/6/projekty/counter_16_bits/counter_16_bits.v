/* module counter_16_bits_on_board(
	input CLOCK_50,
	input [0:0] KEY,
	output [6:0] HEX3, HEX2, HEX1, HEX0);

	wire [15:0] q;
	counter_16_bits counter(CLOCK_50, KEY[0], 1'b1, q);
	decoder_hex_16 dec3(q[15:12], HEX3);
	decoder_hex_16 dec2(q[11:8], HEX2);
	decoder_hex_16 dec1(q[7:4], HEX1);
	decoder_hex_16 dec0(q[3:0], HEX0);

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

module counter_16_bits(
	input clk, areset, enable,
	output reg [15:0] Q);

	always @ (posedge clk, negedge areset)
		if (!areset) Q <= {16{1'b0}};
		else if (enable) Q <= Q + 1'b1;
		else Q <= Q;

endmodule
