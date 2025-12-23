`timescale 1ns / 1ps

module KyberRAM (
    input wire clk,
    input wire we,                  // Write Enable
    input wire [7:0] addr_a,        // Address for Port A (0-255)
    input wire [7:0] addr_b,        // Address for Port B (0-255)
    input wire [11:0] din_a,        // Data Input A
    input wire [11:0] din_b,        // Data Input B
    output reg [11:0] dout_a,       // Data Output A
    output reg [11:0] dout_b        // Data Output B
);

    // 256 words of 12-bit memory
    reg [11:0] mem [0:255];

    // Initialize memory with some test data for simulation
    integer i;
    initial begin
        for (i = 0; i < 256; i = i + 1) begin
            mem[i] = i; // Fill with 0, 1, 2... for testing
        end
    end

    // Synchronous Read/Write
    always @(posedge clk) begin
        if (we) begin
            mem[addr_a] <= din_a;
            mem[addr_b] <= din_b;
        end
        dout_a <= mem[addr_a];
        dout_b <= mem[addr_b];
    end

endmodule
