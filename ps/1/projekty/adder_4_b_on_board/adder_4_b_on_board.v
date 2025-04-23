module adder_4_b_on_board(
	input [9:0] SW,
	output [9:0] LEDR);

	adder_4_b a4(SW[9], SW[3:0], SW[7:4], LEDR[9], LEDR[3:0]);
	assign LEDR[8:4] = {5{1'b0}};

endmodule

module adder_4_b(
	input cin,
	input [3:0] a, b,
	output cout,
	output [3:0] s);

	wire [2:0] c;
	adder_1_b a1_0(cin,  a[0], b[0], c[0], s[0]);
	adder_1_b a1_1(c[0], a[1], b[1], c[1], s[1]);
	adder_1_b a1_2(c[1], a[2], b[2], c[2], s[2]);
	adder_1_b a1_3(c[2], a[3], b[3], cout, s[3]);

endmodule

module adder_1_b(
	input cin, a, b,
	output cout, s);

	assign s = cin ^ a ^ b;
	assign cout = a & b | (a ^ b) & cin;

endmodule
