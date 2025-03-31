module adder_bcd_2_digits_on_board(
    input [8:0] SW,
    output [6:0] HEX5, HEX3, HEX1, HEX0,
    output [9:0] LEDR);

    assign LEDR[8:0] = SW[8:0];
    decoder_hex_10 dec_x(SW[7:4], HEX5);
    decoder_hex_10 dec_y(SW[3:0], HEX3);

    wire [3:0] s1, s0;
    wire error;

    // Logika z modułu adder_bcd_2_digits przeniesiona tutaj
    wire x_error, y_error;
    comparator comp_x(SW[7:4], 4'd9, x_error);
    comparator comp_y(SW[3:0], 4'd9, y_error);
    assign error = x_error | y_error;

    wire [4:0] binary_sum = {1'b0, SW[7:4]} + {1'b0, SW[3:0]} + {3'b000, SW[8]};
    binary_bcd_5_bits conv(binary_sum, s1, s0);

    assign LEDR[9] = error;
    decoder_hex_10 dec_s1(s1, HEX1);
    decoder_hex_10 dec_s0(s0, HEX0);

endmodule