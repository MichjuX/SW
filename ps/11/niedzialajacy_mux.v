one_hot_mux_10x1 #(9) mux({DIN_out, R_out [0:7], G_out},
	DIN, R0, R1, R2, R3, R4, R5, R6, R7, G_Q,
	BusWires);

module one_hot_mux_10x1 #(parameter BITS = 9)(
	input [0:9] s,
	input [BITS-1:0] i0_, i1_, i2_, i3_, i4_, i5_, i6_, i7_, i8_, i9_,
	output [BITS-1:0] out);

	wire [BITS-1:0] i_and_s [9:0];
	assign i_and_s[0] = i0_ & {BITS{s[0]}};
	assign i_and_s[1] = i1_ & {BITS{s[1]}};
	assign i_and_s[2] = i2_ & {BITS{s[2]}};
	assign i_and_s[3] = i3_ & {BITS{s[3]}};
	assign i_and_s[4] = i4_ & {BITS{s[4]}};
	assign i_and_s[5] = i5_ & {BITS{s[5]}};
	assign i_and_s[6] = i6_ & {BITS{s[6]}};
	assign i_and_s[7] = i7_ & {BITS{s[7]}};
	assign i_and_s[8] = i8_ & {BITS{s[8]}};
	assign i_and_s[9] = i9_ & {BITS{s[9]}};
	generate
		genvar bit_index;
		for (bit_index = 0; bit_index <= BITS-1; bit_index = bit_index + 1) begin: forb
			assign out[bit_index] =
				i_and_s[0][bit_index] |
				i_and_s[1][bit_index] |
				i_and_s[2][bit_index] |
				i_and_s[3][bit_index] |
				i_and_s[4][bit_index] |
				i_and_s[5][bit_index] |
				i_and_s[6][bit_index] |
				i_and_s[7][bit_index] |
				i_and_s[8][bit_index] |
				i_and_s[9][bit_index];
		end
	endgenerate

endmodule
