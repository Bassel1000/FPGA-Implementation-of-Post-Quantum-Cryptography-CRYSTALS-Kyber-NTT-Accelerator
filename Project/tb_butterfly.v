`timescale 1ns / 1ps

module tb_butterfly;

    // Inputs to the Unit Under Test (UUT)
    reg [11:0] a;
    reg [11:0] b;
    reg [11:0] w;

    // Outputs from the UUT
    wire [11:0] even;
    wire [11:0] odd;

    // Instantiate the Butterfly Unit
    Butterfly uut (
        .a(a), 
        .b(b), 
        .w(w), 
        .even(even), 
        .odd(odd)
    );

    initial begin
        // --- Test 1: Basic Math ---
        // a=2, b=3, w=1
        // bw = 3 * 1 = 3
        // Even = 2 + 3 = 5
        // Odd = 2 - 3 = -1 -> (wraps to 3328)
        a = 12'd2; b = 12'd3; w = 12'd1;
        #10; // Wait 10 nanoseconds
        $display("Test 1: Inputs(2, 3, 1) -> Even: %d (Exp: 5), Odd: %d (Exp: 3328)", even, odd);

        // --- Test 2: Wrap Around Addition ---
        // a=3328 (max), b=1, w=1
        // bw = 1
        // Even = 3328 + 1 = 3329 -> (wraps to 0)
        // Odd = 3328 - 1 = 3327
        a = 12'd3328; b = 12'd1; w = 12'd1;
        #10;
        $display("Test 2: Inputs(3328, 1, 1) -> Even: %d (Exp: 0), Odd: %d (Exp: 3327)", even, odd);

        // --- Test 3: Multiplication Check ---
        // a=100, b=10, w=100
        // bw = 10 * 100 = 1000
        // Even = 100 + 1000 = 1100
        // Odd = 100 - 1000 = -900 -> (-900 + 3329) = 2429
        a = 12'd100; b = 12'd10; w = 12'd100;
        #10;
        $display("Test 3: Inputs(100, 10, 100) -> Even: %d (Exp: 1100), Odd: %d (Exp: 2429)", even, odd);

        $stop; // Stop simulation
    end

endmodule
