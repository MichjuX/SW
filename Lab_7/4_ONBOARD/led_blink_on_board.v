// sytuacja, kiedy najpierw led świeci przez 0.8 sekundy, a potem jest zgaszony też przez 0.8 sekundy
module led_blink_on_board(
	input CLOCK_50,
	output [7:0] LEDR);

	/* 1 - 1/50000000 s
	x - 0.8 s
	x = (0.8 s) / (1/50000000 s) = 0.8 * 50000000 = 40000000 */
	wire leds_on;
	timer #(40_000_000) t(CLOCK_50, leds_on);

	assign LEDR = {8{leds_on}};

endmodule


