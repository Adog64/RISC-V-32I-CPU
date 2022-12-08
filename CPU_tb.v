`timescale 1ns/1ps

module CPU_tb ();
    reg clk, rst;
    wire[7:0] segFaults;
    wire[31:0] aluResult;
    wire[4:0] aluStatus;

    CPU cpu(.clk(clk), .rst(rst), .seg_faults(segFaults), .Q10(aluResult), .AluStatus(aluStatus));

    always begin
        #5 clk <= ~clk;
    end

    initial begin
        $dumpfile("build/CPU.vcd");
        $dumpvars(0, CPU_tb);
        clk <= 0;
        rst <= 0;
        #20 rst <= 1;
        #20 rst <= 0;
        #100 $stop;

    end

endmodule