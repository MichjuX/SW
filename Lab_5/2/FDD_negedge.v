module FDD_negedge(
    input D, Clk,
    output reg Q,
    output nQ
);

    always @ (negedge Clk)
        Q <= D;

    assign nQ = ~Q;

endmodule