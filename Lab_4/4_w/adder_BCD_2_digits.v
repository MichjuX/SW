module adder_BCD_2_digits (
	input [3:0] X, Y,
	input cin,
	output [0:6] S0, S1,
	output reg error);

	wire [3:0] SUM, M, A;
	wire z, sel, cout;
	
	always @(*) begin
		if(X > 4'd9 || Y > 4'd9)
			error = 1'b1;
		else
			error = 1'b0;
	end

	
	ripple_carry_adder_4_bit ripp(X, Y, cin, SUM, cout);
	comparator_greater_than_9 comp(SUM, z);
	
	assign sel = z | cout;
	
	circuit_A_19 circ(SUM, cout, A);
	mux_2_1_4_bits mux(SUM, A, sel, M);
	
	decoder_hex_10 dec0(M, S0);
	decoder_hex_10 dec1({1'b0, 1'b0, 1'b0, sel}, S1);
		
endmodule
