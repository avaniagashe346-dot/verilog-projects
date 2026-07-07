`timescale 1ns / 1ps

module counter_4bit (
    input wire clk,         // Clock signal
    input wire rst,         // Asynchronous active-high reset
    output reg [3:0] count  // 4-bit register to store output value (0 to 15)
);

    // Sequential logic block triggered on the rising edge of clock or reset
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 4'b0000;      // Asynchronously clear counter to 0
        end else begin
            count <= count + 1'b1; // Increment the count value by 1
        end
    end

endmodule