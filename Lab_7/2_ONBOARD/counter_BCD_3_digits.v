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