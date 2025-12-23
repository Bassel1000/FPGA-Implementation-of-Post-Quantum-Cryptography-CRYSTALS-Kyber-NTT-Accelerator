`timescale 1ns / 1ps

module Butterfly (
    input  wire [11:0] a,     // Upper input coefficient
    input  wire [11:0] b,     // Lower input coefficient
    input  wire [11:0] w,     // Twiddle factor (from Zeta table)
    output wire [11:0] even,  // Upper output (a + bw)
    output wire [11:0] odd    // Lower output (a - bw)
);

    wire [11:0] bw; // Intermediate signal for (b * w)

    // Instance 1: Calculate (b * w) % q
    ModMul mul_unit (
        .a(b), 
        .b(w), 
        .out(bw)
    );

    // Instance 2: Calculate (a + bw) % q
    ModAdd add_unit (
        .a(a), 
        .b(bw), 
        .out(even)
    );

    // Instance 3: Calculate (a - bw) % q
    ModSub sub_unit (
        .a(a), 
        .b(bw), 
        .out(odd)
    );

endmodule
