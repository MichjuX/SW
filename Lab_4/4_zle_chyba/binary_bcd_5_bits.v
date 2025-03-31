module binary_bcd_5_bits(
    input [4:0] binary,
    output [3:0] s1, s0);

    wire [4:0] adjusted = (binary > 5'd9) ? (binary + 5'd6) : binary;
    assign s1 = adjusted[4:1];
    assign s0 = adjusted[0];

endmodule
