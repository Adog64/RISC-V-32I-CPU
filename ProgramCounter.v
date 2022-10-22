module ProgramCounter(input count, input[3:0] incrament, output reg[31:0] step);
    initial begin
        step <= 32'b0;
    end
    always @(posedge count) begin
        step <= step + incrament;
    end
endmodule