module delay_10ms(
	input clock,
	output slow_clock); // zbocze 0 -> 1 w momencie wyzerowania (przekręcenia) licznika

	wire clock_rollover;
	/* 1 - 1/50000000 s
	x - 10/1000 s (10 ms)
	x = (10/1000 s) / (1/50000000 s) = 10/1000 * 50000000 = 500000
	1 cs (setna sekundy) zmienia się co 500_000 taktów zegara */
	counter_modulo_k #(500_000) counter(.clk(clock), .aclr(1'b1), .enable(1'b1), .aload(1'b0), .rollover(clock_rollover));
	assign slow_clock = ~clock_rollover;

endmodule