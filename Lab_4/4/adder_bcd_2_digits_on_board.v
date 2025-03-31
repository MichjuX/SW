module adder_bcd_2_digits_on_board(
    input [8:0] SW,
    output [6:0] HEX5, HEX3, HEX1, HEX0,
    output [9:0] LEDR);

    assign LEDR[8:0] = SW[8:0];
    decoder_hex_10 dec_x(SW[7:4], HEX5);
    decoder_hex_10 dec_y(SW[3:0], HEX3);
    wire [3:0] s1, s0;
    adder_bcd_2_digits adder(SW[7:4], SW[3:0], SW[8], s1, s0, LEDR[9]);
    decoder_hex_10 dec_s1(s1, HEX1);
    decoder_hex_10 dec_s0(s0, HEX0);

endmodule