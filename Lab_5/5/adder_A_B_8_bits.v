module adder_A_B_8_bits(
    input [7:0] A_B,
    input reg_reset, reg_clock,
    output [7:0] reg_value,
	 output cout,
    output [7:0] S
);

reg_N_bits_with_areset reg_A(reg_reset, reg_clock, A_B, reg_value);

assign {cout, S} = reg_value + A_B;

endmodule
