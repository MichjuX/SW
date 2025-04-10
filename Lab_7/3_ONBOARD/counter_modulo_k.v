module counter_modulo_k
    #(parameter k = 20)( // okres licznika
    input clk, aclr, enable, aload,
    input [N-1:0] data,
    output reg [N-1:0] Q,
    output rollover);

    function integer clogb2(input [31:0] v);
        for (clogb2 = 0; v > 0; clogb2 = clogb2 + 1)
            v = v >> 1;
    endfunction

    localparam N = clogb2(k-1); // długość licznika w bitach
    
    initial Q = {N{1'b0}};
    always @ (posedge clk, negedge aclr, posedge aload)
        if (!aclr) Q <= k-1;  // Zmiana: inicjalizacja na maksymalną wartość
        else if (aload) Q <= data;
        else begin
            if (enable) begin
                if (Q == 0) Q <= k-1;  // Zmiana: po osiągnięciu 0 przechodzimy do maksymalnej wartości
                else Q <= Q - 1'b1;   // Zmiana: dekrementacja zamiast inkrementacji
            end
            else Q <= Q;
        end
        
    assign rollover = (Q == 0);  // Zmiana: sygnał rollover aktywny gdy Q == 0

endmodule