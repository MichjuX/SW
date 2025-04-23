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
	counter_modulo_k #(50_000_000) counter(clock, clock_rollover);
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
