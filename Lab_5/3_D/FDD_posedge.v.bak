module FDD_posedge(
    input D, Clk,
    output reg Q,
    output nQ
);

    always @ (posedge Clk)
        Q <= D;

    assign nQ = ~Q;

endmodule
