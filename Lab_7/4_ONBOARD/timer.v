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