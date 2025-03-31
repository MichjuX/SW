module add(
    input [3:0] x, y,
    input cin,
    output [3:0] sum,
    output cout);

    assign {cout, sum} = x + y + cin;

endmodule