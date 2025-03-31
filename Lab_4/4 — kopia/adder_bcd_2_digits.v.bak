module adder_bcd_2_digits(
    input [3:0] x, y,
    input cin,
    output [3:0] s1, s0,
    output error);

    assign error = ((x > 4'd9) | (y > 4'd9)); // syntezuje 2 4-bitowe komparatory
    wire [4:0] binary_sum = {1'b0, x} + {1'b0, y} + {3'b000, cin};
    binary_bcd_5_bits conv(binary_sum, s1, s0);

endmodule