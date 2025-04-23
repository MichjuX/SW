/* module RS_boolean_on_board(
	input [2:0] SW,
	output [0:0] LEDR);

	RS_boolean rs(SW[2], SW[1], SW[0], LEDR[0]);

endmodule */

module RS_boolean(
	input Clk, R, S,
	output Q);

	wire R_g, S_g, Qa, Qb /* synthesis keep */;
	assign R_g = R & Clk;
	assign S_g = S & Clk;
	assign Qa = ~(R_g | Qb);
	assign Qb = ~(S_g | Qa);
	assign Q = Qa;

endmodule
