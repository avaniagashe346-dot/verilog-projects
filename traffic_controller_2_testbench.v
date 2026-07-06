`timescale 1ns / 1ps

module tb_Traffic_Light_Sensor;
    reg clk;
    reg clr;
    reg SNS1;
    reg SNS2;
    wire [1:0] TL1;
    wire [1:0] TL2;

    // Instantiate the design
    Traffic_Light_Sensor uut (
        .clk(clk), 
        .clr(clr), 
        .SNS1(SNS1), 
        .SNS2(SNS2), 
        .TL1(TL1), 
        .TL2(TL2)
    );

    // Generate Clock (toggles every 10ns)
    always #10 clk = ~clk;

    initial begin
        // Initialize inputs
        clk = 0;
        clr = 1;
        SNS1 = 0;
        SNS2 = 0;
        #10;
        
        clr = 0; // Release clear
        #15;

        // Trigger SNS2 to move from S0 -> S1 -> S2
        SNS2 = 1; 
        #40;
        SNS2 = 0;
        #40; // Stays at S2 because SNS1 is 0

        // Trigger SNS1 to move from S2 -> S3 -> S0
        SNS1 = 1;
        #25;
        SNS1 = 0;
        #60;

        $finish;
    end
endmodule