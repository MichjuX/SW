module FSM_one_hot(
	input w, clk, aclr,
	output reg z,
	output [8:0] y);

	localparam [8:0]
		A = 9'b000000001,
		B = 9'b000000010,
		C = 9'b000000100,
		D = 9'b000001000,
		E = 9'b000010000,
		F = 9'b000100000,
		G = 9'b001000000,
		H = 9'b010000000,
		I = 9'b100000000;
	reg [8:0] state = A, next;
	assign y = state;

	always @ (posedge clk, negedge aclr)
		if (~aclr) state <= A;
		else state <= next;

	always @ (*)
		case (state)
			A: if (w) next = F; else next = B;
			B: if (w) next = F; else next = C;
			C: if (w) next = F; else next = D;
			D: if (w) next = F; else next = E;
			E: if (w) next = F; else next = E;
			F: if (w) next = G; else next = B;
			G: if (w) next = H; else next = B;
			H: if (w) next = I; else next = B;
			I: if (w) next = I; else next = B;
			default: next = A;
		endcase

	always @ (*)
		case (state)
			E, I: z = 1'b1;
			default: z = 1'b0;
		endcase

endmodule
