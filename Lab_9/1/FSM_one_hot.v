module FSM_one_hot(
    input w, clk, aclr,
    output reg z,
    output [8:0] y);

    localparam [8:0]
	 // 9-bitowe wektory - zapisane stany (każdy bit reprezentuje oddzielny stan)
	 // Ścieżka zer (A → B → C → D → E)
	 // Ścieżka jedynek (A → F → G → H → I)
        A = 9'b000000001, // 1
        B = 9'b000000010, // 2 z
        C = 9'b000000100, // 3 z
        D = 9'b000001000, // 4 zera
        E = 9'b000010000, // 4+ zer
        F = 9'b000100000, // 2 j
        G = 9'b001000000, // 3 j
        H = 9'b010000000, // 4 jedynki
        I = 9'b100000000; // 4+ jedynek
    reg [8:0] state = A, next;
    assign y = state; // Wyjście y pokazuje aktualny stan

    always @ (posedge clk, negedge aclr)
        if (~aclr) state <= A; // Reset asynchroniczny  
        else state <= next;    // Normalna zmiana stanu

    always @ (*) begin
        next = A;  // Domyślna wartość - zabezpieczenie
        next = (state == A) ? (w ? F : B) : next;
        next = (state == B) ? (w ? F : C) : next;
        next = (state == C) ? (w ? F : D) : next;
        next = (state == D) ? (w ? F : E) : next;
        next = (state == E) ? (w ? F : E) : next;
        next = (state == F) ? (w ? G : B) : next;
        next = (state == G) ? (w ? H : B) : next;
        next = (state == H) ? (w ? I : B) : next;
        next = (state == I) ? (w ? I : B) : next;
    end

    always @ (*) begin
        z = 1'b0;  // Domyślnie 0
        z = (state == E) ? 1'b1 : z;
        z = (state == I) ? 1'b1 : z;
    end

endmodule