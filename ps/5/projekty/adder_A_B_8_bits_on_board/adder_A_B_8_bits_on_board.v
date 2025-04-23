module adder_A_B_8_bits_on_board(
	input [7:0] SW,
	input [1:0] KEY,
	output [6:0] HEX3, HEX2, HEX1, HEX0, HEX5, HEX4,
	output [0:0] LEDR);

	decoder_hex_16 A1(A[7:4], HEX3);
	decoder_hex_16 A0(A[3:0], HEX2);
	decoder_hex_16 B1(SW[7:4], HEX1);
	decoder_hex_16 B0(SW[3:0], HEX0);
	assign LEDR[0] = cout;
	decoder_hex_16 S1(S[7:4], HEX5);
	decoder_hex_16 S0(S[3:0], HEX4);
	
	wire [7:0] A, S; // A - zapisany w rejestrze składnik sumy
	wire cout;
	// jeżeli KEY[1] = 1 (puszczony) -> 0 (wciśnięty), to ~KEY[1] = 0 -> 1, czyli wpisujemy A z SW do rejestru reg_A
	adder_A_B_8_bits adder(SW, ~KEY[0], ~KEY[1], A, cout, S);

endmodule

module adder_A_B_8_bits(
	input [7:0] A_B,
	input reg_reset, reg_clock,
	output [7:0] reg_value, // zapisany w rejestrze składnik sumy
	output cout,
	output [7:0] S);

	// jeżeli reg_clock = 0 -> 1 (zbocze narastające), to wpisujemy A (aktualną wartość A_B) do rejestru reg_A
	reg_N_bits_with_areset reg_A(reg_reset, reg_clock, A_B, reg_value);
	// sumujemy A zapisane w rejestrze reg_A z A_B
	assign {cout, S} = reg_value + A_B;

endmodule

module reg_N_bits_with_areset
	#(parameter N = 8)(
	input reset, clk,
	input [(N-1):0] D,
	output reg [(N-1):0] Q);

	always @ (posedge clk, posedge reset)
		if (reset == 1'b1) Q <= {N{1'b0}};
		// w momencie odebrania zbocza narastającego clk rejestr zapisuje D i zaczyna podawać je na Q
		else Q <= D;

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
