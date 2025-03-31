module FDD_posedge(
    input D, Clk, aclr,
    output reg Q,
    output nQ
);

    always @ (posedge Clk, negedge aclr)
		if (!aclr)
			Q <= 1'b0;
		else
			Q <= D;

    assign nQ = ~Q;

endmodule
