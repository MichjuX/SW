module counter_BCD_3_digits_on_board(
	input CLOCK_50,
	input [0:0] KEY,
	output [6:0] HEX2, HEX1, HEX0,
	output [0:0] LEDR);

	wire [11:0] bcd /* synthesis keep */;
	counter_BCD_3_digits counter(CLOCK_50, KEY[0], bcd, LEDR[0]);
	decoder_hex_10 dec0(bcd[3:0], HEX0);
	decoder_hex_10 dec1(bcd[7:4], HEX1);
	decoder_hex_10 dec2(bcd[11:8], HEX2);

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

module delay_1_sec(
	input clock,
	output slow_clock); // zbocze 0 -> 1 w momencie wyzerowania (przekręcenia) licznika

	wire clock_rollover;
	counter_modulo_k #(50_000_000) counter(.clk(clock), .aclr(1'b1), .enable(1'b1), .rollover(clock_rollover));
	assign slow_clock = ~clock_rollover;

endmodule

module counter_BCD_3_digits(
	input clock,
	input areset,
	output [11:0] bcd, // 3 cyfry BCD po 4 bity
	output max);

	wire c0, c1, c2, c3;
	delay_1_sec delay(clock, c0);
	counter_modulo_k #(10) counter0(c0, areset, 1'b1, bcd[3:0], c1);
	counter_modulo_k #(10) counter1(~c1, areset, 1'b1, bcd[7:4], c2);
	counter_modulo_k #(10) counter2(~c2, areset, 1'b1, bcd[11:8], c3);
	assign max = c1 & c2 & c3;

endmodule

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
	
	initial Q = {N{1'b0}};
	always @ (posedge clk, negedge aclr)
		if (!aclr) Q <= {N{1'b0}};
		else begin
			// zanim sprawdzimy, czy Q == M-1 i ewentualnie wyzerujemy licznik, sprawdzamy, czy na wejściu zezwalającym jest 1
			if (enable) begin
				if (Q == k-1) Q <= {N{1'b0}};
				else Q <= Q + 1'b1;
			end
			else Q <= Q;
		end
		
	assign rollover = (Q == k-1);

endmodule
