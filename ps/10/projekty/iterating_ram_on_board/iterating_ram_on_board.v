module iterating_ram_on_board(
	input CLOCK_50,
	input [9:0] SW,
	input [0:0] KEY,
	output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);

	// pousuwać synthesis keep przed kompilacją na płytę
	wire [4:0] read_addr /* synthesis keep */;
	wire [3:0] q /* synthesis keep */;
	iterating_ram ir(CLOCK_50, SW[3:0], SW[8:4], SW[9], KEY[0], read_addr, q);
	decoder_hex_16 dec_q(q, HEX0);
	decoder_hex_16 dec_data(SW[3:0], HEX1);
	decoder_hex_16 dec_read_addr1({3'b000, read_addr[4]}, HEX3);
	decoder_hex_16 dec_read_addr0(read_addr[3:0], HEX2);
	decoder_hex_16 dec_write_addr1({3'b000, SW[8]}, HEX5);
	decoder_hex_16 dec_write_addr0(SW[7:4], HEX4);

endmodule

module decoder_hex_16(
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
			4'd10: h = 7'b0001000; // 8; A
			4'd11: h = 7'b0000011; // 3; b
			4'd12: h = 7'b0100111; // 39; c
			4'd13: h = 7'b0100001; // 33; d
			4'd14: h = 7'b0000110; // 6; E
			4'd15: h = 7'b0001110; // 14; F
		endcase

endmodule

module iterating_ram(
	input clk,
	input [3:0] data,
	input [4:0] write_addr,
	input write_enable, reset_counter,
	output [4:0] read_addr,
	output [3:0] q);

	wire clk_1_sec;
	delay_1_sec delay(clk, clk_1_sec);
	counter_N_bits #(5) address_counter(clk_1_sec, reset_counter, read_addr);
	ram32x4_2_ports ram(clk, data, read_addr, write_addr, write_enable, q);

endmodule

module counter_N_bits
  #(parameter N = 4)(
  input clock, areset,
  output reg [N-1:0] state);

  initial state = {N{1'b0}};
  always @ (posedge clock, negedge areset)
		if (~areset) state <= {N{1'b0}};
		else state <= state + 1'b1;

endmodule

module delay_1_sec(
	input clock,
	output slow_clock); // zbocze 0 -> 1 w momencie wyzerowania (przekręcenia) licznika

	wire clock_rollover;
	/* 1 - 1/50000000 s
	x - 1 s
	x = (1 s) / (1/50000000 s) = 50000000
	1 s upływa co 50_000_000 taktów zegara */
	// ustawić 50_000_000 przed kompilacją na płytę
	counter_modulo_k #(3) counter(clock, clock_rollover);
	assign slow_clock = ~clock_rollover;

endmodule

module counter_modulo_k
	#(parameter k = 20)( // okres licznika
	input clk,
	output rollover);

	function integer clogb2(input [31:0] v);
		for (clogb2 = 0; v > 0; clogb2 = clogb2 + 1)
			v = v >> 1;
	endfunction

	localparam N = clogb2(k-1); // długość licznika w bitach
	
	reg [N-1:0] Q = {N{1'b0}};
	always @ (posedge clk)
		if (Q == k-1) Q <= {N{1'b0}};
		else Q <= Q + 1'b1;
		
	assign rollover = (Q == k-1);

endmodule
