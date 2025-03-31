module bcd_validator(
    input [3:0] X,
    output reg error);

    always @ (*)
    case (X)
    4'd10, 4'd11, 4'd12, 4'd13, 4'd14, 4'd15: error = 1'b1;
    default: error = 1'b0;
    endcase

endmodule