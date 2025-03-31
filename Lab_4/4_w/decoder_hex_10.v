module decoder_hex_10 (
	input [3:0] x,
	output reg [0:6] h);
	
	always @(*)
		casex(x)
			4'd0: h = 7'b0000001;
			4'd1: h = 7'b1001111;
			4'd2: h = 7'b0010010;
			4'd3: h = 7'b0000110;
			4'd4: h = 7'b1001100;
			4'd5: h = 7'b0100100;
			4'd6: h = 7'b0100000;
			4'd7: h = 7'b0001111;
			4'd8: h = 7'b0000000;
			4'd9: h = 7'b0000100;
			default: h = 7'b1111111;
		endcase
		
endmodule
