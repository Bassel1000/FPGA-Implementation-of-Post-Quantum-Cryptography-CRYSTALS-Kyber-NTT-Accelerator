`timescale 1ns / 1ps

module TwiddleROM (
    input wire [6:0] addr, // 0 to 127
    output reg [11:0] zeta
);

    always @(*) begin
        case (addr)
            // Real Kyber constants (first few)
            7'd0: zeta = 12'd1;
            7'd1: zeta = 12'd1729; 
            7'd2: zeta = 12'd2580;
            7'd3: zeta = 12'd3289;
            // In a real project, you would list all 128 values here
            default: zeta = 12'd1; 
        endcase
    end

endmodule
