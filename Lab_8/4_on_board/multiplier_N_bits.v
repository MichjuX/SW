module multiplier_N_bits
	#(parameter N = 4)(
	input [N-1:0] A, B,
	output [2*N-1:0] P);

	wire [N-1:0] pp[N-1:0]; // cząstkowe iloczyny
	wire [N-1:0] s[N-1:1]; // cząstkowe sumy
	wire cout[N-1:1]; // przeniesienia
	genvar i;
	// tworzenie cząstkowych iloczynyów
	generate
		for(i = 0; i <= N - 1; i = i + 1) begin: bl1
			assign pp[i] = A & {N{B[i]}};
		end
	endgenerate
	// tworzenie cząstkowych sum
	adder_N_bits #(N) ad1({1'b0, pp[0][N-1:1]}, pp[1], 1'b0, s[1], cout[1]);
	generate
		for(i = 2; i <= N - 1; i = i + 1) begin: bl2
			adder_N_bits #(N) adi({cout[i-1], s[i-1][N-1:1]}, pp[i], 1'b0, s[i], cout[i]);
		end
	endgenerate
	// tworzenie ostatecznego iloczynu
	assign P[0] = pp[0][0];
	generate
		for(i = 1; i <= N - 2; i = i + 1) begin: bl3
			assign P[i] = s[i][0];
		end
	endgenerate
	assign P[2*N-2:N-1] = s[N-1];
	assign P[2*N-1] = cout[N-1];

endmodule