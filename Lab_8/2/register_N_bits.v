module register_N_bits
	#(parameter N = 8)(
	input [N-1:0] D,
	input clock, areset,
	output reg [N-1:0] Q);

	initial Q = 0;
	always @ (posedge clock, posedge areset)
		if (areset) Q <= 0;
		else Q <= D;

endmodule