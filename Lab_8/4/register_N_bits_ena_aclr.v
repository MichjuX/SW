module register_N_bits_ena_aclr
	#(parameter N = 8)(
	input [N-1:0] D,
	input clock, aclr, ena,
	output reg [N-1:0] Q);

	initial Q = 0;
	always @ (posedge clock, posedge aclr)
		if (aclr) Q <= 0;
		else if (ena) Q <= D;
		else Q <= Q;

endmodule