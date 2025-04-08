module word_rotate(
    input clock,
    output reg [7:0] char_codes);

    initial char_codes = { 2'b00, 2'b01, 2'b10, 2'b11 };

    // 1 sekunda
    localparam COUNTER_MAX = 50_000_000;
    
    reg [31:0] counter;
    wire slow_clock;
    
    always @(posedge clock) begin
        if (counter >= COUNTER_MAX - 1) begin
            counter <= 0;
        end else begin
            counter <= counter + 1;
        end
    end
    
    assign slow_clock = (counter == COUNTER_MAX - 1);
    
    always @(posedge clock) begin
        if (slow_clock) begin
            char_codes[7:6] <= char_codes[1:0];
            char_codes[5:4] <= char_codes[7:6];
            char_codes[3:2] <= char_codes[5:4];
            char_codes[1:0] <= char_codes[3:2];
        end
    end

endmodule