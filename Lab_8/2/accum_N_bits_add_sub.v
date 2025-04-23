module accum_N_bits_add_sub
	#(parameter N = 8)(
	input [N-1:0] A,
	input clk, aclr, add_sub,
	output [N-1:0] S,
	output reg carry, // sygnał carry ma sens, kiedy interpretujemy S jako liczbę bez znaku (unsigned)
	output reg overflow); // sygnał overflow ma sens, kiedy interpretujemy S jako liczbę ze znakiem (signed)

	wire [N-1:0] S_plus_A;
	wire ad_cout;
	ripple_carry_adder_subtractor #(N) ad(S, A, add_sub, S_plus_A, ad_cout);
	register_N_bits #(N) r(S_plus_A, clk, aclr, S);

	wire of = (S[N-1] & A[N-1] & (~S_plus_A[N-1]) & (~add_sub)) |
		(S[N-1] & (~A[N-1]) & (~S_plus_A[N-1]) & add_sub) |
		((~S[N-1]) & (~A[N-1]) & S_plus_A[N-1] & (~add_sub));
	always @ (posedge clk, posedge aclr)
		if (aclr) begin
			carry <= 0;
			overflow <= 0;
		end
		else begin
			carry <= add_sub ^ ad_cout;
			overflow <= of;
		end

endmodule




