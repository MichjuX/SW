/* module counter_modulo_20_on_board(
	input [2:0] KEY,
	output [4:0] LEDR,
	output [9:9] LEDR);

	counter_modulo_k #(20) counter(KEY[0], KEY[1], KEY[2], LEDR, LEDR[9]);

endmodule */

module counter_modulo_k
	#(parameter k = 20)( // okres licznika
	input clk, aclr, enable,
	output reg [N-1:0] Q,
	output rollover);

	function integer clogb2(input [31:0] v);
		for (clogb2 = 0; v > 0; clogb2 = clogb2 + 1)
			v = v >> 1;
	endfunction

	localparam N = clogb2(k-1); // długość licznika w bitach

	always @ (posedge clk, negedge aclr)
		if (!aclr) Q <= {N{1'b0}};
		else begin
			// zanim sprawdzimy, czy Q == k-1 i ewentualnie wyzerujemy licznik, sprawdzamy, czy na wejściu zezwalającym jest 1
			if (enable) begin
				if (Q == k-1) Q <= {N{1'b0}};
				else Q <= Q + 1'b1;
			end
			else Q <= Q;
		end
		
	assign rollover = (Q == k-1);

endmodule
