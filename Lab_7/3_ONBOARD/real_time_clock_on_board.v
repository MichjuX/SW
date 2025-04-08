module real_time_clock_on_board(
	input CLOCK_50,
	input [7:0] SW,
	input [3:0] KEY,
	output [6:0] HEX5, HEX4, HEX3, HEX2, HEX1, HEX0);

	wire [7:0] m, s, cs;
	real_time_clock rtc(CLOCK_50, ~KEY[0], ~KEY[3], ~KEY[2], ~KEY[1], SW, m, s, cs);

	decoder_hex_10 d0(cs[3:0], HEX0);
	decoder_hex_10 d1(cs[7:4], HEX1);
	decoder_hex_10 d2(s[3:0], HEX2);
	decoder_hex_10 d3(s[7:4], HEX3);
	decoder_hex_10 d4(m[3:0], HEX4);
	decoder_hex_10 d5(m[7:4], HEX5);

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
			default: h = 7'b1111111; // 127
		endcase

endmodule

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
	/* 1 - 1/50000000 s
	x - 10/1000 s (10 ms)
	x = (10/1000 s) / (1/50000000 s) = 10/1000 * 50000000 = 500000
	1 cs (setna sekundy) zmienia się co 500_000 taktów zegara */
	counter_modulo_k #(500_000) counter(.clk(clock), .aclr(1'b1), .enable(1'b1), .aload(1'b0), .rollover(clock_rollover));
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
