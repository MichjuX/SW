module slow_counter_mod_10_on_board(
	input CLOCK_50,
	output [6:0] HEX0);

	wire [3:0] Q;
	slow_counter_mod_10 slow_counter(CLOCK_50, Q);
	decoder_hex_10 decoder(Q, HEX0);

endmodule

module decoder_hex_10(
	input [3:0] binary,
	output reg [6:0] h);

	always @ (*)
		case (binary)
			4'd0: h = 7'b1000000; // 64
			4'd1: h = 7'b1111001; // 121
			4'd2: h = 7'b0100100; // 36
			4'd3: h = 7'b0110000; // 48
			4'd4: h = 7'b0011001; // 25
			4'd5: h = 7'b0010010; // 18
			4'd6: h = 7'b0000010; // 2
			4'd7: h = 7'b1111000; // 120
			4'd8: h = 7'b0000000; // 0
			4'd9: h = 7'b0010000; // 16
			default: h = 7'b1111111;
		endcase

endmodule

module slow_counter_mod_10(
	input clk,
	output [SLOW_COUNTER_BITS-1:0] Q);

	function integer clogb2(input [31:0] v);
		for (clogb2 = 0; v > 0; clogb2 = clogb2 + 1)
			v = v >> 1;
	endfunction
	
	// ceil(log2(50_000_000)) bitów
	localparam FAST_COUNTER_BITS = clogb2(50_000_000 - 1);
	// ceil(log2(10)) bitów
	localparam SLOW_COUNTER_BITS = clogb2(10 - 1);
	
	wire [FAST_COUNTER_BITS-1:0] A;
	counter_mod_M #(50_000_000) fast_counter(clk, 1'b1, 1'b1, A);
	wire e = ~|A; // e = nor(A[0], A[1], ...);
	counter_mod_M #(10) slow_counter(clk, 1'b1, e, Q);

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
