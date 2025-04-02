module decoder_7_seg(
	input [1:0] c,
	output [6:0] h);

	assign h[6] = c[1] & c[0];
	assign h[5] = 1'b0;
	assign h[4] = ~c[1] & c[0];
	assign h[3] = ~c[0];
	assign h[2] = (~c[1] & ~c[0]) | (c[1] & c[0]);
	assign h[1] = 1'b1;
	assign h[0] = c[1] & ~c[0];

endmodule