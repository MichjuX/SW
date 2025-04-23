module accum_N_bits_add_sub
	#(parameter N = 8)(
	input [N-1:0] A,
	input clk, aclr, add_sub,
	output [N-1:0] S,
	output reg carry, // sygnał carry ma sens, kiedy interpretujemy S jako liczbę bez znaku (unsigned)
	output reg overflow1, // sygnał overflow ma sens, kiedy interpretujemy S jako liczbę ze znakiem (signed)
	output reg overflow2);

	wire [N-1:0] S_plus_A;
	wire ad_cout, of2;
	ripple_carry_adder_subtractor #(N) ad(S, A, add_sub, S_plus_A, ad_cout, of2); // oszczędny overflow
	register_N_bits #(N) r(S_plus_A, clk, aclr, S);

	wire of1 = (S[N-1] & A[N-1] & (~S_plus_A[N-1]) & (~add_sub)) |
		(S[N-1] & (~A[N-1]) & (~S_plus_A[N-1]) & add_sub) |
		((~S[N-1]) & (~A[N-1]) & S_plus_A[N-1] & (~add_sub)); // kosztowny overflow
	always @ (posedge clk, posedge aclr)
		if (aclr) begin
			carry <= 0;
			overflow1 <= 0;
			overflow2 <= 0;
		end
		else begin
			carry <= add_sub ^ ad_cout;
			overflow1 <= of1;
			overflow2 <= of2;
		end

endmodule

module ripple_carry_adder_subtractor
	#(parameter N = 4)(
	input [N-1:0] A, B,
	input sub,
	output [N-1:0] S,
	output cout,
	output overflow);

	wire [N-2:0] c;
	assign overflow = c[N-2] ^ cout;
	generate
		genvar i;
		for (i = 0; i < N; i = i + 1)
		begin: ad
			case (i)
				0: full_adder fa(A[i], sub ^ B[i], sub, S[i], c[i]);
				N-1: full_adder fa(A[i], sub ^ B[i], c[i-1], S[i], cout);
				default: full_adder fa(A[i], sub ^ B[i], c[i-1], S[i], c[i]);
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

module register_N_bits
	#(parameter N = 8)(
	input [N-1:0] D,
	input clock, areset,
	output reg [N-1:0] Q);

	initial Q = 0;
	always @ (posedge clock, posedge areset)
		if (areset) Q <= 0;
		else Q <= D;

endmodule
