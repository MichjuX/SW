/* module RS_if_on_board(
	input [2:0] SW,
	output [0:0] LEDR);

	RS_if rs(SW[2], SW[1], SW[0], LEDR[0]);

endmodule */

module RS_if(
	input Clk, R, S, // Clk to wejście enable
	output reg Q,
	output nQ);

	always @ (*)
		if (Clk) begin
			if (S) Q = 1'b1;
			else if (R) Q = 1'b0;
		end
		// https://www.allaboutcircuits.com/textbook/digital/chpt-10/the-gated-s-r-latch/
		// jeżeli Clk = 0, to na Q jest zatrzaśnięta wartość, którą Q miało w momencie zmiany Clk z 1 na 0
	assign nQ = ~Q;

endmodule
