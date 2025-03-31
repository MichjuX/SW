module sumator(
    input [3:0] a, b,
    output [3:0] sum);

    assign sum = a - b;  // Zmiana z dodawania na odejmowanie

endmodule