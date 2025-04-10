module delay_1_sec(
	input clock,
	output slow_clock); // zbocze 0 -> 1 w momencie wyzerowania (przekręcenia) licznika

	wire clock_rollover;
	counter_modulo_k #(50_000_000) counter(.clk(clock), .aclr(1'b1), .enable(1'b1), .rollover(clock_rollover));
	assign slow_clock = ~clock_rollover;

endmodule