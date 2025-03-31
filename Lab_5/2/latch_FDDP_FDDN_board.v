module latch_FFDP_FFDN_board (
    input [9:0] SW,
    output [9:0] LEDR
);

    // Przypisanie sygnałów wejściowych
    wire D = SW[0];
    wire Clk = SW[1];

    // Wyjścia z modułu wewnętrznego
    wire Qa, Qb, Qc;

    // Przypisanie wyjść do diod LED
    assign LEDR[0] = Qa;
    assign LEDR[1] = Qb;
    assign LEDR[2] = Qc;

    // Instancja głównego modułu zatrzasków i przerzutników
    latch_FFDP_FFDN core (
        .D(D),
        .Clock(Clk),
        .Qa(Qa),
        .nQa(),    // nieużywane
        .Qb(Qb),
        .nQb(),    // nieużywane
        .Qc(Qc),
        .nQc()     // nieużywane
    );

endmodule
