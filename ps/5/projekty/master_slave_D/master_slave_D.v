/* module master_slave_D_on_board(
	input [1:0] SW,
	output [0:0] LEDR); 

	master_slave_D ms_latch(SW[0], SW[1], LEDR[0]);

endmodule */

module master_slave_D(
	input D, Clock,
	output Q, nQ);

	wire Qm, Qs /* synthesis keep */;
	latch_D master(~Clock, D, Qm);
	latch_D slave(Clock, Qm, Qs);
	assign Q = Qs;
	assign nQ = ~Qs;

endmodule

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
