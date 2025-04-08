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


