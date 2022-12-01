`timescale 1ns/1ps

module RAM_tb();
    reg RAM_en;
    reg clk;
    reg rst;
    reg write_en;
    reg[10:0] addr;
    reg[31:0] data_in;

    wire[31:0] data_out;
    wire seg_fault;

    RAM ram(.clk(clk), .rst(rst), .addr(addr), .din(data_in), .write_en(write_en), .dout(data_out)), .seg_fault(seg_fault);

    always begin
        #5 clk <= ~clk;
    end

    initial begin
        $dumpfile("build/RAM.vcd");
        $dumpvars(0, RAM_tb);
        clk <= 0;
        rst <= 1; #10 rst <= 0;
        // write to RAM
        write_en <= 1;
        addr <= {3'b100, 8'b0000_0101};
        data_in <= 5;

        // read from RAM
        #10 write_en <= 0;
        #15 $stop;
    end
endmodule