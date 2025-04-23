module accum_N_bits_assign_on_board (
    input [7:0] SW,          // SW7-0 jako wejście A
    input [1:0] KEY,         // KEY1 jako clk, KEY0 jako aclr
    output [9:0] LEDR,       // LEDR7-0 jako S, LEDR8 jako carry, LEDR9 jako overflow
    output [6:0] HEX0,       // Wyświetlacz jednostek S
    output [6:0] HEX1,       // Wyświetlacz dziesiątek S
    output [6:0] HEX2,       // Wyświetlacz jednostek A
    output [6:0] HEX3        // Wyświetlacz dziesiątek A
);

    wire [7:0] S;
    wire carry, overflow;
    
    // Instancja akumulatora
    accum_N_bits_assign #(8) accumulator (
        .A(SW[7:0]),
        .clk(~KEY[1]),       // Przyciski są aktywne w stanie niskim
        .aclr(~KEY[0]),      // Przyciski są aktywne w stanie niskim
        .S(S),
        .carry(carry),
        .overflow(overflow)
    );
    
    assign LEDR[7:0] = S;
    assign LEDR[8] = carry;
    assign LEDR[9] = overflow;
    
// Dekodery 7-segmentowe dla wyświetlaczy (używając Twojego dekodera)
    decoder_hex_10 decoder_S0 (
        .binary(S[3:0]),
        .h(HEX0)
    );
    
    decoder_hex_10 decoder_S1 (
        .binary(S[7:4]),
        .h(HEX1)
    );
    
    decoder_hex_10 decoder_A0 (
        .binary(SW[3:0]),
        .h(HEX2)
    );
    
    decoder_hex_10 decoder_A1 (
        .binary(SW[7:4]),
        .h(HEX3)
    );

endmodule