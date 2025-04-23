module one_hot_mux
	#(parameter BITS = 9)(
	input [9:0] s,
	input [BITS-1:0] i0_, i1_, i2_, i3_, i4_, i5_, i6_, i7_, i8_, i9_,
	output reg [BITS-1:0] out);

	/* always @ (*)
		case (s) /* synthesis full_case parallel_case * /
			10'b0000000001: out = i0_;
			10'b0000000010: out = i1_;
			10'b0000000100: out = i2_;
			10'b0000001000: out = i3_;
			10'b0000010000: out = i4_;
			10'b0000100000: out = i5_;
			10'b0001000000: out = i6_;
			10'b0010000000: out = i7_;
			10'b0100000000: out = i8_;
			10'b1000000000: out = i9_;
			default: out = {BITS{1'b0}};
		endcase */

	/* always @ (*)
		casex (s)
			10'bxxxxxxxxx1: out = i0_;
			10'bxxxxxxxx1x: out = i1_;
			10'bxxxxxxx1xx: out = i2_;
			10'bxxxxxx1xxx: out = i3_;
			10'bxxxxx1xxxx: out = i4_;
			10'bxxxx1xxxxx: out = i5_;
			10'bxxx1xxxxxx: out = i6_;
			10'bxx1xxxxxxx: out = i7_;
			10'bx1xxxxxxxx: out = i8_;
			10'b1xxxxxxxxx: out = i9_;
			default: out = {BITS{1'b0}};
		endcase */

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
