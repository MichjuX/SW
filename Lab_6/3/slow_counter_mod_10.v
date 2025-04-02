module slow_counter_mod_10(
	input clk,
	output [SLOW_COUNTER_BITS-1:0] Q);

	function integer clogb2(input [31:0] v);
		for (clogb2 = 0; v > 0; clogb2 = clogb2 + 1)
			v = v >> 1;
	endfunction
	
	// ceil(log2(5)) bitów
	localparam FAST_COUNTER_BITS = clogb2(5 - 1);
	// ceil(log2(10)) bitów
	localparam SLOW_COUNTER_BITS = clogb2(10 - 1);

	wire [FAST_COUNTER_BITS-1:0] A;
	counter_mod_M #(5) fast_counter(clk, 1'b1, 1'b1, A);
	wire e = ~|A; // e = nor(A[0], A[1], ...);
	counter_mod_M #(10) slow_counter(clk, 1'b1, e, Q);

endmodule