`timescale 1ns/1ps

module alu (
    input wire [7:0] A,          // Operand A
    input wire [7:0] B,          // Operand B
    input wire [3:0] opcode,     // Operation selector
    output reg [15:0] result,    // Operation result
    output reg carry,            // Carry / Borrow flag
    output reg zero,             // Zero flag (result == 0)
    output reg overflow          // Overflow flag
);

    reg [8:0] temp;

    parameter ADD  = 4'b0000, SUB  = 4'b0001, MUL  = 4'b0010, DIV  = 4'b0011,
              AND  = 4'b0100, OR   = 4'b0101, XOR  = 4'b0110, NOT  = 4'b0111,
              SHL  = 4'b1000, SHR  = 4'b1001, XNOR = 4'b1010, NAND = 4'b1011,
              NOR  = 4'b1100, SLT  = 4'b1101, ZERO = 4'b1110, PASS = 4'b1111;

    always @(*) begin
        carry = 0; 
        overflow = 0; 
        temp = 0;
        
        case (opcode)
            ADD: begin
                temp = {1'b0, A} + {1'b0, B};
                result = {8'b0, temp[7:0]};
                carry = temp[8];
                overflow = (~A[7] & ~B[7] & result[7]) | (A[7] & B[7] & ~result[7]); 
            end
            SUB: begin
                temp = {1'b0, A} - {1'b0, B};
                result = {8'b0, temp[7:0]};
                carry = (A < B);
            end
            MUL: begin 
                result = A * B; 
                overflow = |result[15:8]; 
            end
            DIV: begin
                result = (B != 0) ? {8'b0, A / B} : 16'hFFFF;
            end
            AND:  result = {8'b0, A & B};
            OR:   result = {8'b0, A | B};
            XOR:  result = {8'b0, A ^ B};
            NOT:  result = {8'b0, ~A};
            SHL:  begin result = {8'b0, A << 1}; carry = A[7]; end
            SHR:  begin result = {8'b0, A >> 1}; carry = A[0]; end
            XNOR: result = {8'b0, ~(A ^ B)};
            NAND: result = {8'b0, ~(A & B)};
            NOR:  result = {8'b0, ~(A | B)};
            SLT:  result = (A < B) ? 16'h0001 : 16'h0000;
            ZERO: result = 16'h0000;
            PASS: result = {8'b0, A};
            default: result = 16'hXXXX;
        endcase 
        
        zero = (result == 16'h0000);
    end
endmodule