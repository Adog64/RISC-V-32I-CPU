`timescale 1ns/1ps

module ROM_tb();
    reg[7:0] addr;
    reg clk, rst;
    wire[31:0] data;

    // ROM(input clk, input rst, input [7:0]addr, output [31:0]dout)
    ROM rom(.clk(clk), .rst(rst), .addr(addr), .dout(data));

    always begin
      #5 clk <= ~clk;
    end

    initial begin
        $dumpfile("build/ROM.vcd");
        $dumpvars(0,ROM_tb);
        clk <= 0;
        rst <= 1; #10 rst <= 0;
        #15 addr <= 0;
        #15 addr <= 4;
        #15 addr <= 8;
        #20;
        $stop;
    end
endmodule