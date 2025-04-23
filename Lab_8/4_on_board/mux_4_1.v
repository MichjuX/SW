module mux_4_1
	#(parameter N = 8)(
	input [N-1:0] inf0, inf1, inf2, inf3,
	input [1:0] s,
	output reg [N-1:0] out);

	always @ (*)
		case (s)
			2'd0: out = inf0;
			2'd1: out = inf1;
			2'd2: out = inf2;
			2'd3: out = inf3;
		endcase

endmodule
