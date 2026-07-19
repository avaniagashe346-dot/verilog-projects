`timescale 1ns / 1ps

module fsm_detector (
    input wire clk,       // Clock signal
    input wire rst,       // Synchronous Reset
    input wire din,       // Serial Data Input
    output reg dout       // Output (Goes High '1' when "101" is detected)
);

    // State Encoding using 2-bit local parameters
    reg [1:0] current_state, next_state;
    localparam IDLE = 2'b00,
               S1   = 2'b01,
               S10  = 2'b10;

    // ----- Block 1: Sequential State Register -----
    always @(posedge clk) begin
        if (rst) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    // ----- Block 2: Combinational Next-State Logic -----
    always @(*) begin
        case (current_state)
            IDLE: begin
                if (din == 1'b1) next_state = S1;
                else             next_state = IDLE;
            end
            
            S1: begin
                if (din == 1'b0) next_state = S10;
                else             next_state = S1; // Stay here if it's another 1
            end
            
            S10: begin
                if (din == 1'b1) next_state = S1;  // Pattern "101" completed, overlaps with next sequence
                else             next_state = IDLE;
            end
            
            default: next_state = IDLE;
        endcase
    end

    // ----- Block 3: Combinational Output Logic (Mealy Style) -----
    always @(*) begin
        case (current_state)
            S10: begin
                if (din == 1'b1) dout = 1'b1; // Output goes high the instant the final '1' arrives
                else             dout = 1'b0;
            end
            default: dout = 1'b0;
        endcase
    end

endmodule
