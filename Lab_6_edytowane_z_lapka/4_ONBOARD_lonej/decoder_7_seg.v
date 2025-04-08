module decoder_7_seg(
	input [1:0] C,
	output [6:0] h);

	assign h[0] = C[1] & ~C[0];
	assign h[1] = C[0];
	assign h[2] = C[0] & ~C[1];
	assign h[3] = ~C[1] & ~C[0];
	assign h[4] = C[0] & C[1];
	assign h[5] = 1'b0;
	assign h[6] = C[1] & ~C[0];

endmodule