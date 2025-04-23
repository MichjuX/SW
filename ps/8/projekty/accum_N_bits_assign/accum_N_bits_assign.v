module accum_N_bits_assign 
	#(parameter N = 8)(
	input [N-1:0] A,
	input clk, aclr,
	output [N-1:0] S,
	output reg carry,
	output reg overflow);

	wire [N-1:0] S_plus_A;
	wire ad_cout;
	assign {ad_cout, S_plus_A} = S + A;
	register_N_bits #(N) r(S_plus_A, clk, aclr, S);

	wire of = (S[N-1] & A[N-1] & (~S_plus_A[N-1])) | ((~S[N-1]) & (~A[N-1]) & S_plus_A[N-1]);
	always @ (posedge clk, posedge aclr)
		if (aclr) begin
			carry <= 0;
			overflow <= 0;
		end
		else begin
			carry <= ad_cout;
			overflow <= of;
		end

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
