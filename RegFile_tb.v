`timescale 1ns/1ps

module RegFile_tb();
    reg [31:0] din;
    reg [4:0] rs1, rs2, rd;
    reg r, clk, rst;
    wire [31:0] a, b;

    RegFile rf(.clk(clk), .rst(rst), .read(r), .rs1(rs1), .rs2(rs2), .data_in(din), .rd(rd), .rs1_out(a), .rs2_out(b));

    always begin
        #5 clk <= ~clk;
    end

    initial begin
        $dumpfile("build/RegFile.vcd");
        $dumpvars(0, RegFile_tb);

        clk <= 0;
        rst <= 1; #5 rst <= 0; // reset
        // write 1
        #15 r<=0;
        din <= 500;
        rd <= 5;
        // write 2
        #15 r<=0;
        din <= 50;
        rd <= 11;
        // read 1
        #15 r<=1;
        rs1 <= 5;
        rs2 <= 11;
        // write 3
        #15 r<=0;
        din <= 69;
        rd <= 23;
        // read 2
        #15 r<=1;
        rs1 <= 11;
        rs2 <= 23;
        // read 3
        #15;
        rs1 <= 23;
        rs2 <= 5;
        #15 $stop;
    end
endmodule