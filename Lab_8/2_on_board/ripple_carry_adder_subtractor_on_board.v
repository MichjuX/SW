module ripple_carry_adder_subtractor_on_board (
    input [7:0] SW,      
    input [1:0] KEY,    
    output [9:0] LEDR,      
    output [6:0] HEX0,      
    output [6:0] HEX1,      
    output [6:0] HEX2,   
    output [6:0] HEX3      
);

    wire [3:0] S;
    wire cout, overflow;
    
    // Instancja sumatora/odejmatora 4-bitowego
    ripple_carry_adder_subtractor #(4) adder_sub (
        .A(SW[7:4]),         // A - starsze 4 bity SW
        .B(SW[3:0]),         // B - młodsze 4 bity SW
        .sub(~KEY[0]),       // Tryb odejmowania (aktywny wysoki, KEY jest aktywny niski)
        .S(S),
        .cout(cout)
    );
    
    // Detekcja overflow dla operacji ze znakiem
    assign overflow = (~SW[7] & ~SW[3] & S[3]) | (SW[7] & SW[3] & ~S[3]);
    
    // Podłączenie wyjść do LEDów
    assign LEDR[3:0] = S;
    assign LEDR[8] = cout;
    assign LEDR[9] = overflow;
    assign LEDR[7:4] = 4'b0;  // Nieużywane LEDy gasimy
    
    // Dekodery 7-segmentowe
    decoder_hex_10 decoder_S (
        .binary(S),
        .h(HEX0)
    );
    
    decoder_hex_10 decoder_S_hi (
        .binary(4'b0),       // Dla 4-bit wyniku wyświetlamy tylko na HEX0
        .h(HEX1)
    );
    
    decoder_hex_10 decoder_B (
        .binary(SW[3:0]),
        .h(HEX2)
    );
    
    decoder_hex_10 decoder_A (
        .binary(SW[7:4]),
        .h(HEX3)
    );

endmodule