module FSM_1_always(
	input w, clk, nclr,
	output reg z,
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

	always @ (posedge clk)
		if (~nclr) state <= A;
		else case (state)
			A: begin
				if (w) begin state = F; z = 1'b0; end
				else begin state = B; z = 1'b0; end
			end
			B: begin
				if (w) begin state = F; z = 1'b0; end
				else begin state = C; z = 1'b0; end
			end
			C: begin
				if (w) begin state = F; z = 1'b0; end
				else begin state = D; z = 1'b0; end
			end
			D: begin
				if (w) begin state = F; z = 1'b0; end
				else begin state = E; z = 1'b1; end
			end
			E: begin
				if (w) begin state = F; z = 1'b0; end
				else begin state = E; z = 1'b1; end
			end
			F: begin
				if (w) begin state = G; z = 1'b0; end
				else begin state = B; z = 1'b0; end
			end
			G: begin
				if (w) begin state = H; z = 1'b0; end 
				else begin state = B; z = 1'b0; end
			end
			H: begin
				if (w) begin state = I; z = 1'b1; end
				else begin state = B; z = 1'b0; end
			end
			I: begin
				if (w) begin state = I; z = 1'b1; end
				else begin state = B; z = 1'b0; end
			end
			default: begin z = 1'b0; state = A; end
		endcase

endmodule
