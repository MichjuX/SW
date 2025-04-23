// sytuacja, kiedy najpierw led świeci przez 0.5 sekundy, a potem jest zgaszony też przez 0.5 sekundy
module led_blink_on_board(
	input CLOCK_50,
	output [7:0] LEDR);

	/* 1 - 1/50000000 s
	x - 0.5 s
	x = (0.5 s) / (1/50000000 s) = 0.5 * 50000000 = 25000000 */
	wire leds_on;
	timer #(25_000_000) t(CLOCK_50, leds_on);

	assign LEDR = {8{leds_on}};

endmodule

module timer
	// liczba cykli zegara, po których toggled zmienia wartość na przeciwną
	#(parameter TIMEOUT = 50_000_000)
	(input clock,
	output reg toggled);

	function integer clogb2(input [31:0] v);
		for (clogb2 = 0; v > 0; clogb2 = clogb2 + 1)
			v = v >> 1;
	endfunction

	localparam N = clogb2(TIMEOUT - 1);

	initial toggled = 1'b1;
	reg [N-1:0] counter = TIMEOUT - 1;
	always @ (posedge clock)
		if (counter == 0) begin
			counter <= TIMEOUT - 1;
			toggled <= ~toggled;
		end
		else counter <= counter - 1;

endmodule
