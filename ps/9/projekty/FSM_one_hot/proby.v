module FSM_one_hot(
	input w, clk, aclr,
	output reg z,
	output [8:0] y);

	localparam [8:0]
		ZERO = 9'b000000000,
		A = 9'b000000001,
		B = 9'b000000010,
		C = 9'b000000100,
		D = 9'b000001000,
		E = 9'b000010000,
		F = 9'b000100000,
		G = 9'b001000000,
		H = 9'b010000000,
		I = 9'b100000000;
		/* A = 9'b000000000,
		B = 9'b000000001,
		C = 9'b000000010,
		D = 9'b000000100,
		E = 9'b000001000,
		F = 9'b000010000,
		G = 9'b000100000,
		H = 9'b001000000,
		I = 9'b010000000; */
	reg [8:0] state = ZERO;
	wire [8:0] next;
	assign y = state;

	/* always @ (posedge clk, negedge aclr) begin
		if (~aclr) begin
			state <= A;
			z <= 1'b0;
		end
		else begin
			case (state)
				A: if (w) begin state = F; z = 1'b0; end else begin state = B; z = 1'b0; end
				B: if (w) begin state = F; z = 1'b0; end else begin state = C; z = 1'b0; end
				C: if (w) begin state = F; z = 1'b0; end else begin state = D; z = 1'b0; end
				D: if (w) begin state = F; z = 1'b0; end else begin state = E; z = 1'b1; end
				E: if (w) begin state = F; z = 1'b0; end else begin state = E; z = 1'b1; end
				F: if (w) begin state = G; z = 1'b0; end else begin state = B; z = 1'b0; end
				G: if (w) begin state = H; z = 1'b0; end else begin state = B; z = 1'b0; end
				H: if (w) begin state = I; z = 1'b1; end else begin state = B; z = 1'b0; end
				I: if (w) begin state = I; z = 1'b1; end else begin state = B; z = 1'b0; end
				// default: begin state = ZERO; state = A; end
			endcase
		end
	end */

	// assign z = ((state == E) ? 1'b1 : (state == I) ? 1'b1 : 1'b0);

	always @ (posedge clk, negedge aclr)
		if (~aclr) begin state = ZERO; state = A; end
		else state <= next;

	/* always @ (*) begin
		case (state)
			ZERO: next = A;
			A: if (w) next = F; else next = B;
			B: if (w) next = F; else next = C;
			C: if (w) next = F; else next = D;
			D: if (w) next = F; else next = E;
			E: if (w) next = F; else next = E;
			F: if (w) next = G; else next = B;
			G: if (w) next = H; else next = B;
			H: if (w) next = I; else next = B;
			I: if (w) next = I; else next = B;
			default: next = ZERO;
		endcase
	end */
	
	next_state ns(state, w, aclr, next);

	// assign z = state[8] | state[4];

	always @ (*)
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

module next_state(
	input [8:0] state,
	input w, aclr,
	output reg [8:0] next);

	always @ (*) begin
		next[0] = ~aclr;
		next[1] = ~w & (state[8] | state[7] | state[6] | state[5] | state[0]) & aclr;
		next[2] = ~w & state[1] & aclr;
		next[3] = ~w & state[2] & aclr;
		next[4] = ~w & (state[4] | state[3]) & aclr;
		next[5] = w & (state[4] | state[3] | state[2] | state[1] | state[0]) & aclr;
		next[6] = w & state[5] & aclr;
		next[7] = w & state[6] & aclr;
		next[8] = w & (state[8] | state[7]) & aclr;
	end

endmodule
