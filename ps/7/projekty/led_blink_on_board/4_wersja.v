// sytuacja, kiedy najpierw led świeci przez 0.5 sekundy, a potem jest zgaszony przez 0.8 sekundy
module led_blink_on_board(
	input CLOCK_50,
	output [7:0] LEDR);

	/* 1 - 1/50000000 s
	x - 0.8 s
	x = (0.8 s) / (1/50000000 s) = 0.8 * 50000000 = 40000000 */
	localparam ON_LENGTH = 5, OFF_LENGTH = 8; // 0.5 s, 0.8 s
	timer #(ON_LENGTH, OFF_LENGTH) t(CLOCK_50, led_on);

	assign LEDR = {8{led_on}};

endmodule

module timer
	#(parameter ON_LENGTH = 25_000_000, OFF_LENGTH = 40_000_000)
	(input clock,
	output value);

	function integer clogb2(input [31:0] v);
	 for (clogb2 = 0; v > 0; clogb2 = clogb2 + 1)
		v = v >> 1;
	endfunction

	localparam FULL_CYCLE_LENGTH = ON_LENGTH + OFF_LENGTH;
	localparam BITS = clogb2(FULL_CYCLE_LENGTH - 1);

	reg [BITS-1:0] counter = FULL_CYCLE_LENGTH - 1;
	always @ (posedge clock)
		if (counter == 0) counter <= FULL_CYCLE_LENGTH - 1;
		else counter <= counter - 1;
		 
	assign value = ~(counter < FULL_CYCLE_LENGTH - ON_LENGTH);

endmodule
