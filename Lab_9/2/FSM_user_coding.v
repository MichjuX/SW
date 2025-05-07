module FSM_user_coding(
	input w, clk, aclr,
	output reg z,
	output [3:0] y);

	reg [3:0] state, next;
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
		else state <= next;

	always @ (*) // opis funkcji przejść
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

	always @ (*) // opis funkcji wyjść
		case (state)
			A: z = 1'b0;
			B: z = 1'b0;
			C: z = 1'b0;
			D: z = 1'b0;
			E: z = 1'b1;
			F: z = 1'b0;
			G: z = 1'b0;
			H: z = 1'b0;
			I: z = 1'b1;
			default: z = 1'b0;
		endcase

endmodule
