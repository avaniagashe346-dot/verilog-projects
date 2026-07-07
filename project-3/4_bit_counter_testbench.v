`timescale 1ns / 1ps

module counter_4bit_tb;

    // Inputs to the DUT declared as registers
    reg clk;
    reg rst;

    // Outputs from the DUT declared as wires
    wire [3:0] count;

    // Instantiate the Device Under Test (DUT)
    counter_4bit uut (
        .clk(clk),
        .rst(rst),
        .count(count)
    );

    // Generate Clock: Toggles every 5ns, creating a total 10ns clock period
    always #5 clk = ~clk;

    // Create a VCD dump file for your Waveform Viewer
    initial begin
        $dumpfile("counter_waveform.vcd");
        $dumpvars(0, counter_4bit_tb);
    end

    // Stimulus block
    initial begin
        // Initialize signals and assert active Reset
        clk = 0;
        rst = 1;
        #15;          // Hold reset for 15ns
        
        rst = 0;      // Release Reset to let it count
        #180;         // Run for 180ns (shows a full 0-15 loop and rollover)
        
        rst = 1;      // Force reset high mid-count to test override
        #12;          
        rst = 0;      // Release it again
        
        #40;          
        $finish;      // End simulation
    end

    // Monitor Block: Automatically prints updates to the console
    initial begin
        $display("====================================================");
        $display("      Simulation Started: 4-Bit Up Counter          ");
        $display("====================================================");
        $monitor("Time = %3dns | Reset = %b | Count = %2d (Hex: %h | Bin: %b)", 
                 $time, rst, count, count, count);
    end

endmodule