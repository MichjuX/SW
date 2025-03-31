module comparator(
    input [3:0] a, b,
    output reg greater);

    always @(*)
    begin
        greater = (a > b);
    end

endmodule