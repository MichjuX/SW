module reg_N_bits_with_areset
    #(parameter N = 8)(
    input reset, clk,
    input [(N-1):0] D,
    output reg [(N-1):0] Q
);

always @ (posedge clk, posedge reset)
    if (reset == 1'b1)
        Q <= {N{1'b0}};
    else
        Q <= D;

endmodule
