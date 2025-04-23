// wersja z wykładu 9.2
module ram32x4_array(
	input [4:0] address,
	input clk,
	input [3:0] data,
	input wren,
	output [3:0] q);

	reg [3:0] memory_array[31:0];
	reg [4:0] reg_address;
	reg [3:0] reg_data;
	reg reg_wren;
	always @ (posedge clk) begin
		reg_address <= address;
		reg_data <= data;
		reg_wren <= wren;
	end
	always @ (*)
		if (reg_wren) memory_array[reg_address] = reg_data;
	assign q = memory_array[reg_address];

endmodule

/*
// wersja z wykładu 9.1
module ram32x4_array(
	input [4:0] address,
	input clk,
	input [3:0] data,
	input wren,
	output reg [3:0] q);

	reg [3:0] memory_array[31:0];
	always @ (posedge clk)
		if (wren) begin // zapis
			memory_array[address] <= data;
			q <= data;
		end
		else // odczyt
			q <= memory_array[address];

endmodule
*/