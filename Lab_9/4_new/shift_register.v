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