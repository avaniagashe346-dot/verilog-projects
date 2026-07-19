`timescale 1ns / 1ps

module fsm_detector_tb;

    // Inputs to the FSM (Declared as registers)
    reg clk;
    reg rst;
    reg din;

    // Outputs from the FSM (Declared as wires)
    wire dout;

    // Instantiate the Device Under Test (DUT)
    fsm_detector uut (
        .clk(clk),
        .rst(rst),
        .din(din),
        .dout(dout)
    );

    // Generate Clock: Toggles every 5ns (10ns total clock cycle period)
    always #5 clk = ~clk;

    // Stimulus block
    initial begin
        // Step 1: Initialize signals and apply Reset
        clk = 0;
        rst = 1;
        din = 0;
        #15; // Hold reset through the first rising edge
        
        rst = 0; // Release reset
        
        // Step 2: Feed serial stream into the FSM on each clock period (10ns intervals)
        // Testing sequence: 1 -> 0 -> 1 (First detection)
        #10 din = 1; 
        #10 din = 0; 
        #10 din = 1; // At this moment, dout should go HIGH!
        
        // Testing overlapping sequence: -> 1 -> 0 -> 1 (Second detection)
        #10 din = 1; 
        #10 din = 0; 
        #10 din = 1; // At this moment, dout should go HIGH again!
        
        // Feed a non-matching bit to return to IDLE
        #10 din = 0;
        #10 din = 0;

        #20;
        $finish; // End simulation
    end

    // Monitor text output in ModelSim Transcript panel
    initial begin
        $display("====================================================");
        $display("         Starting Mealy FSM Simulation              ");
        $display("====================================================");
        $monitor("Time = %3dns | State = %b | Input = %b | Output = %b", 
                 $time, uut.current_state, din, dout);
    end

endmodule
