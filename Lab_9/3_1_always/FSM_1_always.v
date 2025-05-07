module FSM_1_always(
	input w, clk, aclr,
	output z,
	output [3:0] y);

	reg [3:0] state;
	assign y = state;
	localparam [3:0]
		A = 4'b0000, // 0
		B = 4'b0001, // 1
		C = 4'b0010, // 2
		D = 4'b0011, // 3
		E = 4'b0100, // 4
		F = 4'b0101, // 5
		G = 4'b0110, // 6
		H = 4'b0111, // 7
		I = 4'b1000; // 8

	always @ (posedge clk, negedge aclr)
		if (~aclr) state <= A;
		else case (state)
			A: if (w) state = F; else state = B;
			B: if (w) state = F; else state = C;
			C: if (w) state = F; else state = D;
			D: if (w) state = F; else state = E;
			E: if (w) state = F; else state = E;
			F: if (w) state = G; else state = B;
			G: if (w) state = H; else state = B;
			H: if (w) state = I; else state = B;
			I: if (w) state = I; else state = B;
			default: state = A;
		endcase

	assign z = ((state == A) ? 1'b0 : (
		(state == B) ? 1'b0 : (
		(state == C) ? 1'b0 : (
		(state == D) ? 1'b0 : (
		(state == E) ? 1'b1 : (
		(state == F) ? 1'b0 : (
		(state == G) ? 1'b0 : (
		(state == H) ? 1'b0 : (
		(state == I) ? 1'b1 : 1'b0)))))))));

endmodule
