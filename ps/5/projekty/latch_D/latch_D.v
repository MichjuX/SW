/* module latch_D_on_board(
	input [1:0] SW,
	output [0:0] LEDR); 

	latch_D latch(SW[1], SW[0], LEDR[0]);

endmodule */

module latch_D(
	input Clk, D,
	output Q);

	wire S = D, R = ~D, S_g, R_g, Qa, Qb;
	assign S_g = ~(S & Clk);
	assign R_g = ~(R & Clk);
	assign Qa = ~(S_g & Qb);
	assign Qb = ~(R_g & Qa);
	assign Q = Qa;

endmodule


/* module latch_D(
	input Clk, D,
	output reg Q);

	always @ (*)
		if (Clk) Q = D;

endmodule */
