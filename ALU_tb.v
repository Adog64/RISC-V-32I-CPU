`timescale 1ns/1ps

`define ADD 4'b0000
`define SUB 4'b1000
`define AND 4'b0111
`define OR 4'b0110
`define XOR 4'b0100

module ALU_tb();
    reg[31:0] A, B;
    reg[3:0] AluOp;
    reg clk;

    wire[31:0] result;
    wire[4:0] status;

    // input clk, input [31:0]A, input [31:0]B, input [3:0]op, output reg [31:0]result, output reg [4:0]status
    ALU alu(.clk(clk), .A(A), .B(B), .op(AluOp), .result(result), .status(status));

    always begin
        #5 clk <= ~clk;
    end

    initial begin
        $dumpfile("build/ALU.vcd");
        $dumpvars(0, ALU_tb);
        clk <= 0;
        #10;
        A <= 9;
        B <= 10;
        AluOp <= `ADD;
        #10;
        AluOp <= `SUB;
        #10;
        A <= 10;
        #10;
        A <= 1;
        B <= 1;
        AluOp <= `AND;
        #15;
        $stop;
    end

endmodule