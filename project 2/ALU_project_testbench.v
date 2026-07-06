`timescale 1ns/1ps

module alu_tb;
    reg [7:0] A, B;
    reg [3:0] opcode;
    wire [15:0] result;
    wire carry, zero, overflow;

    // Instantiate Device Under Test
    alu dut (
        .A(A), .B(B), .opcode(opcode),
        .result(result), .carry(carry),
        .zero(zero), .overflow(overflow)
    );

    // VCD dump for waveform viewer
    initial begin
        $dumpfile("alu_waveform.vcd");
        $dumpvars(0, alu_tb);
    end

    integer pass = 0, fail = 0;

    // Self-checking task
    task check;
        input [7:0] a, b;
        input [3:0] op;
        input [15:0] expected;
        input [79:0] name;
        begin
            A = a; B = b; opcode = op; #10;
            if (result === expected) begin
                $display("PASS %-8s A=%3d B=%3d => %0d", name, a, b, result);
                pass = pass + 1;
            end else begin
                $display("FAIL %-8s A=%3d B=%3d => got=%0d expected=%0d",
                         name, a, b, result, expected);
                fail = fail + 1; 
            end
        end
    endtask

    initial begin
        $display("==========================================");
        $display(" ALU Testbench — 8-bit, 16 operations");
        $display("==========================================");

        // Arithmetic operations
        check(15, 10, 4'b0000, 25, "ADD");
        check(50, 30, 4'b0001, 20, "SUB");
        check(12, 11, 4'b0010, 132, "MUL");
        check(100, 5, 4'b0011, 20, "DIV"); 

        // Logical operations
        check(8'hAA, 8'h55, 4'b0100, 16'h0000, "AND");
        check(8'hAA, 8'h55, 4'b0101, 16'h00FF, "OR");
        check(8'hFF, 8'hAA, 4'b0110, 16'h0055, "XOR");
        check(8'hAA, 8'h00, 4'b0111, 16'h0055, "NOT");
        check(8'hFF, 8'hFF, 4'b1010, 16'h00FF, "XNOR");
        check(8'hFF, 8'hFF, 4'b1011, 16'h0000, "NAND");
        check(8'hFF, 8'h00, 4'b1100, 16'h0000, "NOR");

        // Shift operations
        check(8'h0F, 0, 4'b1000, 16'h001E, "SHL");
        check(8'hF0, 0, 4'b1001, 16'h0078, "SHR");

        // Special operations
        check(3, 5, 4'b1101, 16'h0001, "SLT(T)");
        check(7, 3, 4'b1101, 16'h0000, "SLT(F)");
        check(99, 0, 4'b1110, 16'h0000, "ZERO");
        check(42, 0, 4'b1111, 16'h002A, "PASS");

        $display("");
        $display("Result: %0d PASS | %0d FAIL", pass, fail);
        $display("==========================================");
        $finish;
    end
endmodule