module bcd_2_digit(
    input [7:0] SW,
    output [9:0] LEDR,
    output [6:0] HEX1, HEX0);

    assign LEDR[7:0] = SW[7:0];
    decoder_hex_10 dec1(SW[7:4], HEX1[6:0]);
    bcd_validator val1(SW[7:4], LEDR[9]);
    decoder_hex_10 dec0(SW[3:0], HEX0[6:0]);
    bcd_validator val0(SW[3:0], LEDR[8]);

endmodule