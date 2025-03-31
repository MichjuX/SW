module RS_gates_onboard(
    input [2:0] SW,    // SW[2] = Clk, SW[1] = R, SW[0] = S
    output [0:0] LEDR  // LEDR[0] = Q
);

// Przypisanie sygnałów wejściowych
wire Clk = SW[2];
wire R = SW[1];
wire S = SW[0];

// Instancja głównego modułu RS_gates
RS_gates rs_inst (
    .Clk(Clk),
    .R(R),
    .S(S),
    .Q(LEDR[0])
);

endmodule