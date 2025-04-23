module detector_with_shift_reg(
	input w, clk, aclr,
	output z);

	wire [3:0] sr0_state, sr1_state;
	shift_register #(4, 4'b1111) sr0(clk, aclr, w, sr0_state);
	shift_register #(4, 4'b0000) sr1(clk, aclr, w, sr1_state);
	assign z = (~|sr0_state) | (&sr1_state);

endmodule

module shift_register
  #(parameter N = 4, INITIAL_VALUE = 4'b0000)(
  input clock, aclr,
  input d_first,
  output reg [N-1:0] state);

  initial state = INITIAL_VALUE;
  always @ (posedge clock, negedge aclr)
    if (~aclr) state <= INITIAL_VALUE;
    else state <= {state[N-2:0], d_first};

endmodule
