`timescale 1ns / 1ps

module ModAdd (
    input  wire [11:0] a,
    input  wire [11:0] b,
    output wire [11:0] out
);
    // 13 bits to capture potential overflow before reduction
    wire [12:0] sum;
    
    assign sum = a + b;
    
    // Logic: If sum >= 3329, subtract 3329. Else, keep sum.
    assign out = (sum >= 13'd3329) ? (sum - 13'd3329) : sum[11:0];

endmodule
