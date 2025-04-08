// sytuacja, kiedy najpierw led świeci przez 0.5 sekundy, a potem jest zgaszony przez 0.8 sekundy
module led_blink_on_board(
	input CLOCK_50,
	output [7:0] LEDR);

	/* 1 - 1/50000000 s
	x - 0.8 s
	x = (0.8 s) / (1/50000000 s) = 0.8 * 50000000 = 40000000 */
	wire rollover0, rollover1, led_on;
	FFT fft(1'b1, ~(rollover0 | rollover1), led_on);
	timer #(25_000_000) t0(CLOCK_50, led_on, rollover0); // 0.5 s
	timer #(40_000_000) t1(CLOCK_50, ~led_on, rollover1); // 0.8 s

	assign LEDR = {8{led_on}};

endmodule

module FFT(
	input T, clk,
	output reg Q);

	initial Q = 1'b0;
	always @ (posedge clk)
		if (T) Q <= ~Q;
		else Q <= Q;

endmodule

module timer
	#(parameter TIMEOUT = 50_000_000)
	(input clock, enable,
	output rollover);

	function integer clogb2(input [31:0] v);
		for (clogb2 = 0; v > 0; clogb2 = clogb2 + 1)
			v = v >> 1;
	endfunction

	localparam N = clogb2(TIMEOUT - 1);

	reg [N-1:0] counter = TIMEOUT - 1;
	always @ (posedge clock)
		if (enable) begin
			if (counter == 0) counter <= TIMEOUT - 1;
			else counter <= counter - 1;
		end
		else counter <= counter;
		
	assign rollover = (counter == 0);

endmodule
