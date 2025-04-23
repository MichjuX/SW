module real_time_clock(
	input clock, toggle_enable, m_aload, s_aload, cs_aload,
	input [7:0] data,
	// minuty, sekundy, centysekundy; na każdą jednostkę czasu 2 cyfry BCD po 4 bity
	output [7:0] m, s, cs);

	reg enable = 1'b0;
	always @ (posedge toggle_enable)
		enable <= ~enable;

	wire c1, c2, c3, c4, c5;
	wire [3:0] h0, h1, h2, h4;
	wire [2:0] h3, h5;
	assign cs = {h1, h0};
	assign s = {1'b0, h3, h2};
	assign m = {1'b0, h5, h4};

	wire c0;
	delay_10ms delay(clock, c0);

	counter_modulo_k #(10) count_cs0(c0, 1'b1, enable, cs_aload, data[3:0], h0, c1);
	counter_modulo_k #(10) count_cs1(~c1, 1'b1, 1'b1, cs_aload, data[7:4], h1, c2);
	counter_modulo_k #(10) count_s0(~c2, 1'b1, 1'b1, s_aload, data[3:0], h2, c3);
	counter_modulo_k #(6) count_s1(~c3, 1'b1, 1'b1, s_aload, data[6:4], h3, c4);
	counter_modulo_k #(10) count_m0(~c4, 1'b1, 1'b1, m_aload, data[3:0], h4, c5);
	counter_modulo_k #(6) count_m1(~c5, 1'b1, 1'b1, m_aload, data[6:4], h5);

endmodule

module delay_10ms(
	input clock,
	output slow_clock); // zbocze 0 -> 1 w momencie wyzerowania (przekręcenia) licznika

	wire clock_rollover;
	// 1 cs (setna sekundy) zmienia się co 3 takty zegara
	counter_modulo_k #(3) counter(.clk(clock), .aclr(1'b1), .enable(1'b1), .aload(1'b0), .rollover(clock_rollover));
	assign slow_clock = ~clock_rollover;

endmodule

module counter_modulo_k
	#(parameter k = 20)( // okres licznika
	input clk, aclr, enable, aload,
	input [N-1:0] data,
	output reg [N-1:0] Q,
	output rollover);

	function integer clogb2(input [31:0] v);
		for (clogb2 = 0; v > 0; clogb2 = clogb2 + 1)
			v = v >> 1;
	endfunction

	localparam N = clogb2(k-1); // długość licznika w bitach
	
	initial Q = {N{1'b0}};
	always @ (posedge clk, negedge aclr, posedge aload)
		if (!aclr) Q <= {N{1'b0}};
		else if (aload) Q <= data;
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
