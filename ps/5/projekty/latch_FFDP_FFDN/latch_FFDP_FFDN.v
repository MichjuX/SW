/* module latch_FFDP_FFDN_on_board(
	input [1:0] SW, Clock,
	output [2:0] LEDR);

	D_latch latch(SW[0], SW[1], LEDR[0]);
	D_flip_flop_posedge ffp(SW[0], SW[1], LEDR[1]);
	D_flip_flop_posedge ffn(SW[0], SW[1], LEDR[2]);

endmodule */

module latch_FFDP_FFDN(
	input D, Clock,
	output Qa, nQa, Qb, nQb, Qc, nQc);

	D_latch latch(D, Clock, Qa, nQa);
	D_flip_flop_posedge ffp(D, Clock, Qb, nQb);
	D_flip_flop_negedge ffn(D, Clock, Qc, nQc);

endmodule

module D_latch(
	input D, Clk,
	output reg Q,
	output nQ);

	always @ (D, Clk)
		if (Clk) Q = D;
	assign nQ = ~Q;

endmodule

module D_flip_flop_posedge(
	input D, Clk,
	output reg Q,
	output nQ);

	always @ (posedge Clk)
		Q <= D;
	assign nQ = ~Q;

endmodule

module D_flip_flop_negedge(
	input D, Clk,
	output reg Q,
	output nQ);

	always @ (negedge Clk)
		Q <= D;
	assign nQ = ~Q;

endmodule
