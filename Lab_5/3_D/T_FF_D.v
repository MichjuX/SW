module T_FF_D (
    input T, clk, aclr,
    output Q, nQ
);

wire D;

assign D = T ^ Q;

FDD_posedge FDD_p(D, clk, aclr, Q, nQ);

endmodule
