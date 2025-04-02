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