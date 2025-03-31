module adder_4_b(
	input cin,
	input [3:0] a, b,
	output cout,
	output [3:0] s);
	
	wire [2:0] c;
	adder_1_b a1_0(cin, a[0], b[0], c[0], s[0]);
	adder_1_b a1_1(c[0], a[1], b[1], c[1], s[1]);
	adder_1_b a1_2(c[1], a[2], b[2], c[2], s[2]);
	adder_1_b a1_3(c[2], a[3], b[3], cout, s[3]);
endmodule
