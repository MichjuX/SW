module binary_bcd_4_bits(
    input [3:0] v,
    output [3:0] di, d0);

    wire v_greater_than_9;
    comparator comp(v, 4'd9, v_greater_than_9);

    wire [3:0] v_minus_10;
    sumator sub(v, 4'b1010, v_minus_10); // 4'b1010 to 10 w systemie dziesiętnym

    wire [3:0] lower_bcd_digit;
    mux_2_1_4_bits mux(v, v_minus_10, v_greater_than_9, lower_bcd_digit);
    assign di = {3'b000, v_greater_than_9};
    assign d0 = lower_bcd_digit;

endmodule