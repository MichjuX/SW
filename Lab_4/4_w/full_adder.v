module full_adder(
	input A, B, cin,
	output S, cout);
	
	assign S = A ^ B ^ cin;
	assign cout = A & B | (A ^ B) & cin;

endmodule
