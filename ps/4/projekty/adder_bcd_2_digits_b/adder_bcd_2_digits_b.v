module adder_bcd_2_digits_b(
	input [3:0] A, B,
	input c0,
	output [3:0] S1, S0);

	reg c1;
	reg [3:0] Z0;
	// suma A + B + c0 może być równa maksymalnie 19, a to zmieści się dopiero na 5 bitach
	wire [4:0] T0 = A + B + c0;
	always @ (*) begin
		if (T0 > 5'd9) begin
			Z0 = 4'd10;
			c1 = 1'b1;
		end
		else begin
			Z0 = 4'd0;
			c1 = 1'b0;
		end
	end
	// S0 jest 4-bitowe, więc najwyższy piąty bit (zawsze równy 0) różnicy T0 - Z0 zostanie odrzucony
	assign S0 = T0 - {1'b0, Z0};
	assign S1 = {3'b000, c1};

endmodule
