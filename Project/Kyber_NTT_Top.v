`timescale 1ns / 1ps

module Kyber_NTT_Top (
    input wire clk,
    input wire rst,
    input wire start,
    output wire done,
    output wire [11:0] debug_ram_out_a,
    output wire [11:0] debug_ram_out_b
);

    // Internal Wires
    wire [7:0] addr_a, addr_b;
    wire [11:0] ram_out_a, ram_out_b;
    wire [11:0] bfly_out_even, bfly_out_odd;
    wire [11:0] zeta;
    wire we;
    
    // 1. NEW WIRE for the ROM Address
    wire [6:0] rom_addr_wire; // <--- FIX 1: Create the wire

    // 2. Instantiate Controller
    NTT_Control control_unit (
        .clk(clk), .rst(rst), .start(start),
        .ram_addr_a(addr_a), .ram_addr_b(addr_b),
        .ram_we(we), 
        .rom_addr(rom_addr_wire), // <--- FIX 2: Connect the Controller output
        .done(done)
    );

    // 3. Instantiate RAM
    KyberRAM ram_unit (
        .clk(clk), .we(we),
        .addr_a(addr_a), .addr_b(addr_b),
        .din_a(bfly_out_even), .din_b(bfly_out_odd),
        .dout_a(ram_out_a), .dout_b(ram_out_b)
    );

    // 4. Instantiate Twiddle ROM
    TwiddleROM rom_unit (
        .addr(rom_addr_wire), // <--- FIX 3: Connect to the wire (was hardcoded 7'd1)
        .zeta(zeta)
    );

    // 5. Instantiate Butterfly Unit
    Butterfly math_engine (
        .a(ram_out_a), 
        .b(ram_out_b), 
        .w(zeta), 
        .even(bfly_out_even), 
        .odd(bfly_out_odd)
    );
    
    assign debug_ram_out_a = ram_out_a;
    assign debug_ram_out_b = ram_out_b;

endmodule
