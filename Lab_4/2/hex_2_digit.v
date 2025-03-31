module hex_2_digit(
    input [7:0] SW,
    output [7:0] LEDR,
    output [6:0] HEX1, HEX0
);

    assign LEDR[7:0] = SW[7:0];
    decoder_hex_16 dec1(SW[7:4], HEX1[6:0]);
    decoder_hex_16 dec0(SW[3:0], HEX0[6:0]);

endmodule