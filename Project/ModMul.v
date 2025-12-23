`timescale 1ns / 1ps

module ModMul (
    input  wire [11:0] a,
    input  wire [11:0] b,
    output wire [11:0] out
);
    // Product can be up to 12x12 = 24 bits
    wire [23:0] product;
    
    assign product = a * b;
    
    // The modulus operator gives the remainder
    assign out = product % 13'd3329;

endmodule
