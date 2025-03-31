module T_FF_behavioral (
    input clk, aclr, T,
    output reg Q,
    output nQ
);

assign nQ = ~Q;

always @ (posedge clk, negedge aclr)
    if (!aclr)
        Q <= 1'b0;
    else if (T)
        Q <= ~Q;
    else
        Q <= Q;

endmodule
