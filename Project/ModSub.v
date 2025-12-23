`timescale 1ns / 1ps

module ModSub (
    input  wire [11:0] a,
    input  wire [11:0] b,
    output wire [11:0] out
);
    wire [12:0] diff;
    
    // Logic: If a < b, the result would be negative. 
    // In modular math, we handle this by adding the modulus (3329).
    // Example: 2 - 5 (mod 3329) = -3 + 3329 = 3326.
    
    assign diff = (a >= b) ? (a - b) : (a + 13'd3329 - b);
    
    assign out = diff[11:0];

endmodule
