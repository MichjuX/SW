/* module RS_gates_on_board(
	input [2:0] SW,
	output [0:0] LEDR);

	RS_gates rs(SW[2], SW[1], SW[0], LEDR[0]);

endmodule */

module RS_gates(
	input Clk, R, S,
	output Q);

	wire R_g, S_g, Qa, Qb /* synthesis keep */;
	and(R_g, R, Clk);
	and(S_g, S, Clk);
	nor(Qa, R_g, Qb);
	nor(Qb, S_g, Qa);
	assign Q = Qa;

endmodule
