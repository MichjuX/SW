module word_rotate(
	input clock,
	output reg [7:0] char_codes);

	initial char_codes = { 2'b00, 2'b01, 2'b10, 2'b11 };

	function integer clogb2(input [31:0] v);
		for (clogb2 = 0; v > 0; clogb2 = clogb2 + 1)
			v = v >> 1;
	endfunction

	// ceil(log2(5)) bitów
	localparam FAST_COUNTER_BITS = clogb2(5 - 1);

	wire [FAST_COUNTER_BITS-1:0] A;
	counter_mod_M #(5) fast_counter(clock, 1'b1, 1'b1, A);
	// przy zmianie A = 4 -> 0 slow_counter = 1 -> 0
	// przy zmianie A = 0 -> 1 slow_counter = 0 -> 1
	wire slow_clock = |A; // e = or(A[0], A[1], ...);
	// cykliczny rejestr przesuwny o długości 4 i szerokości 2-bitów
	always @ (posedge slow_clock) begin
		char_codes[7:6] <= char_codes[1:0];
		char_codes[1:0] <= char_codes[3:2];
		char_codes[3:2] <= char_codes[5:4];
		char_codes[5:4] <= char_codes[7:6];
	end

endmodule

module counter_mod_M
	#(parameter M = 16)( // okres licznika
	input clk, aclr, enable,
	output reg [BITS-1:0] Q);

	function integer clogb2(input [31:0] v);
		for (clogb2 = 0; v > 0; clogb2 = clogb2 + 1)
			v = v >> 1;
	endfunction

	localparam BITS = clogb2(M-1); // długość licznika w bitach

	always @ (posedge clk, negedge aclr)
		if (!aclr) Q <= {BITS{1'b0}};
		else begin
			// zanim sprawdzimy, czy Q == M-1 i ewentualnie wyzerujemy licznik, sprawdzamy, czy na wejściu zezwalającym jest 1
			if (enable) begin
				if (Q == M-1) Q <= {BITS{1'b0}};
				else Q <= Q + 1'b1;
			end
			else Q <= Q;
		end

endmodule
