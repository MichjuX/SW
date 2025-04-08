module delay_10ms(
	input clock,
	output slow_clock); // zbocze 0 -> 1 w momencie wyzerowania (przekręcenia) licznika

	wire clock_rollover;
	// 1 cs (setna sekundy) zmienia się co 3 takty zegara
	counter_modulo_k #(3) counter(.clk(clock), .aclr(1'b1), .enable(1'b1), .aload(1'b0), .rollover(clock_rollover));
	assign slow_clock = ~clock_rollover;

endmodule
