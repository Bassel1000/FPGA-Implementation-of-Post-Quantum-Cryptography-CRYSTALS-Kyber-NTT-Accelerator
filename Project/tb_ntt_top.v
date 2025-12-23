`timescale 1ns / 1ps

module tb_ntt_top;

    // Inputs
    reg clk;
    reg rst;
    reg start;

    // Outputs
    wire done;
    wire [11:0] debug_ram_out_a;
    wire [11:0] debug_ram_out_b;

    // Instantiate the Unit Under Test (UUT)
    Kyber_NTT_Top uut (
        .clk(clk), 
        .rst(rst), 
        .start(start), 
        .done(done),
        .debug_ram_out_a(debug_ram_out_a),
        .debug_ram_out_b(debug_ram_out_b)
    );

    // Clock Generation (10ns period)
    always #5 clk = ~clk;

    initial begin
        // Initialize Inputs
        clk = 0;
        rst = 1;
        start = 0;

        // Reset the system
        #100;
        rst = 0;
        #20;

        // Start the NTT process
        $display("Starting NTT Control Logic Simulation...");
        start = 1;
        #10;
        start = 0;

        // Wait for the 'done' signal
        wait(done);
        #20;

        $display("--- Processing Complete ---");
        
        // VERIFICATION
        // Based on our Logic:
        // Initial Mem[0] = 0
        // Initial Mem[128] = 128
        // Twiddle w = 1
        //
        // Calculation:
        // b * w = 128 * 1 = 128
        // New Mem[0] (Even) = 0 + 128 = 128
        // New Mem[128] (Odd) = 0 - 128 = -128 -> (wraps to 3201)
        
        // We need to peek into the RAM to verify. 
        // In ModelSim, we can access internal signals using dot notation:
        // uut.ram_unit.mem[index]
        
        if (uut.ram_unit.mem[0] == 12'd128 && uut.ram_unit.mem[128] == 12'd3201) begin
            $display("SUCCESS: Memory updated correctly!");
            $display("Mem[0]   = %d (Expected 128)", uut.ram_unit.mem[0]);
            $display("Mem[128] = %d (Expected 3201)", uut.ram_unit.mem[128]);
        end else begin
            $display("FAILURE: Incorrect values in RAM.");
            $display("Mem[0]   = %d (Expected 128)", uut.ram_unit.mem[0]);
            $display("Mem[128] = %d (Expected 3201)", uut.ram_unit.mem[128]);
        end

        $stop;
    end
      
endmodule
