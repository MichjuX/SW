module reg_N_bits_with_areset #(
    parameter N = 4      // Domyślna szerokość 4 bity
)(
    input wire clk,      // Zegar (zbocze narastające)
    input wire areset,   // Asynchroniczne zerowanie (aktywne HIGH)
    input wire [N-1:0] D, // Wejście danych
    output reg [N-1:0] Q  // Wyjście rejestru
);

always @(posedge clk, posedge areset) begin
    if (areset)          // Asynchroniczne zerowanie
        Q <= {N{1'b0}};  // Wypełnij zerami (np. 4'b0000 dla N=4)
    else                 // Normalna praca
        Q <= D;          // Zapis danych na zboczu narastającym
end

endmodule