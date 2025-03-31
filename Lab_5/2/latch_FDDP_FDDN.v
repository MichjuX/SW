module latch_FDDP_FDDN(
    input D, clk,
    output Qa, nQa,
    output Qb, nQb,
    output Qc, nQc
);

D_latch latch(D, clk, Qa, nQa);
FDD_posedge FDD_p(D, clk, Qb, nQb);
FDD_negedge FDD_n(D, clk, Qc, nQc);

endmodule
