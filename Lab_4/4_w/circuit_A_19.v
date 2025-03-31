module circuit_A_19(
	input [3:0] S,
	input cout,
	output reg [3:0] A);
	
	always @(*) begin
		if(cout == 1'b1)
			casex(S)
				4'd0: A = 4'd6;
				4'd1: A = 4'd7;
				4'd2: A = 4'd8;
				4'd3: A = 4'd9;
				default: A = S;
			endcase
		else
			casex(S)
				4'd10: A = 4'd0;
				4'd11: A = 4'd1;
				4'd12: A = 4'd2;
				4'd13: A = 4'd3;
				4'd14: A = 4'd4;
				4'd15: A = 4'd5;
				default: A = S;
			endcase
	end
		
endmodule
