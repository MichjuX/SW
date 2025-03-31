module adder_bcd_2_digits_b( 
input [3:0] A, B, 
input C0, 
output [3:0] S1, S0);
reg C1;
	reg [3:0] Z0;
	wire [4:0] T0 = A + B + C0;
	always @ (*) begin
   	 if (T0 > 5'd9) begin
        Z0 = 4'd10;
        C1 = 1'b1;
    end
    else begin
        Z0 = 4'd0;
        C1 = 1'b0;
   	 end
	end
	
	assign S0 = T0 - {1'b0, Z0};
	assign S1 = {3'b000, C1};
 
endmodule
