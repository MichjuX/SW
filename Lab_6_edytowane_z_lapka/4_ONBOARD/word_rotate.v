module word_rotate(
	input clock,
	output reg [7:0] char_codes);

	initial char_codes = { 2'b00, 2'b01, 2'b10, 2'b11 };

	function integer clogb2(input [31:0] v);
		for (clogb2 = 0; v > 0; clogb2 = clogb2 + 1)
			v = v >> 1;
	endfunction

	localparam FAST_COUNTER_BITS = clogb2(50_000_000 - 1);

	wire [FAST_COUNTER_BITS-1:0] A;
	counter_mod_M #(50_000_000) fast_counter(clock, 1'b1, 1'b1, A); // A = 50000000 -> 0 slow_counter = 1 -> 0 A = 0 -> 1 slow_counter = 0 -> 1
	
	wire slow_clock = |A;
	// rejestr przesuwny
	always @ (posedge slow_clock) begin
		char_codes[7:6] <= char_codes[1:0];
		char_codes[1:0] <= char_codes[3:2];
		char_codes[3:2] <= char_codes[5:4];
		char_codes[5:4] <= char_codes[7:6];
	end

endmodule

