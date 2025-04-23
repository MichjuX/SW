module buffered_multiplier_N_bits_on_board(
	input [9:0] SW,
	input [1:0] KEY,
	output [6:0] HEX3, HEX2, HEX1, HEX0,
	output [7:0] LEDR);

	wire [15:0] P;
	buffered_multiplier_N_bits #(8) buf_mul(SW[7:0], ~KEY[1], ~KEY[0], SW[9], SW[8], P, LEDR);

	decoder_hex_16 dec3(P[15:12], HEX3);
	decoder_hex_16 dec2(P[11:8], HEX2);
	decoder_hex_16 dec1(P[7:4], HEX1);
	decoder_hex_16 dec0(P[3:0], HEX0);

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

module buffered_multiplier_N_bits
	#(parameter N = 8)(
	input [N-1:0] Data,
	input clk, aclr, EA, EB,
	output [2*N-1:0] P,
	output [N-1:0] A_B);

	wire [N-1:0] A, B;
	register_N_bits_ena_aclr #(N) r_A(Data, clk, aclr, EA, A);
	register_N_bits_ena_aclr #(N) r_B(Data, clk, aclr, EB, B);
	mux_4_1 #(N) mux({N{1'b0}}, B, A, {N{1'b0}}, {EA, EB}, A_B);

	wire [2*N-1:0] mul_P;
	multiplier_N_bits #(N) mul(A, B, mul_P);
	register_N_bits_ena_aclr #(2*N) r_P(mul_P, clk, aclr, 1'b1, P);

endmodule

module register_N_bits_ena_aclr
	#(parameter N = 8)(
	input [N-1:0] D,
	input clock, aclr, ena,
	output reg [N-1:0] Q);

	initial Q = 0;
	always @ (posedge clock, posedge aclr)
		if (aclr) Q <= 0;
		else if (ena) Q <= D;
		else Q <= Q;

endmodule

module mux_4_1
	#(parameter N = 8)(
	input [N-1:0] inf0, inf1, inf2, inf3,
	input [1:0] s,
	output reg [N-1:0] out);

	always @ (*)
		case (s)
			2'd0: out = inf0;
			2'd1: out = inf1;
			2'd2: out = inf2;
			2'd3: out = inf3;
		endcase

endmodule

module multiplier_N_bits
	#(parameter N = 4)(
	input [N-1:0] A, B,
	output [2*N-1:0] P);

	wire [N-1:0] pp[N-1:0]; // cząstkowe iloczyny
	wire [N-1:0] s[N-1:1]; // cząstkowe sumy
	wire cout[N-1:1]; // przeniesienia
	genvar i;
	// tworzenie cząstkowych iloczynyów
	generate
		for(i = 0; i <= N - 1; i = i + 1) begin: bl1
			assign pp[i] = A & {N{B[i]}};
		end
	endgenerate
	// tworzenie cząstkowych sum
	adder_N_bits #(N) ad1({1'b0, pp[0][N-1:1]}, pp[1], 1'b0, s[1], cout[1]);
	generate
		for(i = 2; i <= N - 1; i = i + 1) begin: bl2
			adder_N_bits #(N) adi({cout[i-1], s[i-1][N-1:1]}, pp[i], 1'b0, s[i], cout[i]);
		end
	endgenerate
	// tworzenie ostatecznego iloczynu
	assign P[0] = pp[0][0];
	generate
		for(i = 1; i <= N - 2; i = i + 1) begin: bl3
			assign P[i] = s[i][0];
		end
	endgenerate
	assign P[2*N-2:N-1] = s[N-1];
	assign P[2*N-1] = cout[N-1];

endmodule

module adder_N_bits
	#(parameter N = 4)(
	input [N-1:0] A, B,
	input cin,
	output [N-1:0] S,
	output cout);

	wire [N-2:0] c;
	generate
		genvar i;
		for (i = 0; i < N; i = i + 1)
		begin: ad
			case (i)
				0: full_adder fa(A[i], B[i], cin, S[i], c[i]);
				N-1: full_adder fa(A[i], B[i], c[i-1], S[i], cout);
				default: full_adder fa(A[i], B[i], c[i-1], S[i], c[i]);
			endcase
		end
	endgenerate

endmodule

module full_adder(
	input a, b, cin,
	output s, cout);

	assign s = cin ^ (a ^ b);
	assign cout = a & b | (a ^ b) & cin;

endmodule
