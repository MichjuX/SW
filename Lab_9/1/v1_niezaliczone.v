module FSM_one_hot(
	input w, clk, nclr,
	output z,
	output [8:0] y);

	reg [8:0] s = 9'b000000001;
	assign y = s;
	// opis funkcji przejść
	always @ (posedge clk) begin
		s[0] <= ~nclr;
		s[1] <= ~w & (s[8] | s[7] | s[6] | s[5] | s[0]) & nclr;
		s[2] <= ~w & s[1] & nclr;
		s[3] <= ~w & s[2] & nclr;
		s[4] <= ~w & (s[4] | s[3]) & nclr;
		s[5] <= w & (s[4] | s[3] | s[2] | s[1] | s[0]) & nclr;
		s[6] <= w & s[5] & nclr;
		s[7] <= w & s[6] & nclr;
		s[8] <= w & (s[8] | s[7]) & nclr;
	end

	assign z = s[8] | s[4]; // opis funkcji wyjść

endmodule
