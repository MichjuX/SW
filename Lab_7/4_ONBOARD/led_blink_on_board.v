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

module timer
	// liczba cykli zegara, po których slow_clock zmienia wartość na przeciwną
	#(parameter HALF_CYCLE = 50_000_000)
	(input clock,
	output reg slow_clock);

	function integer clogb2(input [31:0] v);
		for (clogb2 = 0; v > 0; clogb2 = clogb2 + 1)
			v = v >> 1;
	endfunction

	localparam N = clogb2(HALF_CYCLE - 1);

	initial slow_clock = 1'b1;
	reg [N-1:0] counter = HALF_CYCLE - 1;
	always @ (posedge clock)
		if (counter == 0) begin
			counter <= HALF_CYCLE - 1;
			slow_clock <= ~slow_clock;
		end
		else counter <= counter - 1;

endmodule
