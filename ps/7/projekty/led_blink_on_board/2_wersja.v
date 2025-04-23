// sytuacja, kiedy najpierw led świeci przez 0.5 sekundy, a potem jest zgaszony przez 0.8 sekundy
module led_blink_on_board(
	input CLOCK_50,
	output [7:0] LEDR);

	/* 1 - 1/50000000 s
	x - 0.8 s
	x = (0.8 s) / (1/50000000 s) = 0.8 * 50000000 = 40000000 */
	wire t0_out, t1_out /* synthesis keep */;
	timer #(5, 1'b1) t0(CLOCK_50, ~t1_out, t0_out); // 0.5 s
	timer #(8, 1'b0) t1(CLOCK_50, ~t0_out, t1_out); // 0.8 s

	assign LEDR = {8{t0_out}};

endmodule

module timer
	// liczba cykli zegara, po których toggled zmienia wartość na przeciwną
	#(parameter TIMEOUT = 50_000_000,
	parameter INITIAL_VALUE = 1'b1)
	(input clock, enable,
	output reg toggled);

	function integer clogb2(input [31:0] v);
		for (clogb2 = 0; v > 0; clogb2 = clogb2 + 1)
			v = v >> 1;
	endfunction

	localparam N = clogb2(TIMEOUT - 1);

	initial toggled = INITIAL_VALUE;
	reg [N-1:0] counter = TIMEOUT - 1;
	always @ (posedge clock)
		if (enable) begin
			if (counter == 0) begin
				counter <= TIMEOUT - 1;
				toggled <= ~toggled;
			end
			else counter <= counter - 1;
		end
		else
			counter <= counter;

endmodule
