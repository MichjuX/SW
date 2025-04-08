// sytuacja, kiedy najpierw led świeci przez 0.8 sekundy, a potem jest zgaszony też przez 0.8 sekundy
module led_blink(
	input clock,
	output [7:0] led);

	/* 1 - 1/50000000 s
	x - 0.8 s
	x = (0.8 s) / (1/50000000 s) = 0.8 * 50000000 = 40000000 */
	wire leds_on;
	timer #(10) t(clock, leds_on);

	assign led = {8{leds_on}};

endmodule


