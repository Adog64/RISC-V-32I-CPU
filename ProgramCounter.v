module ProgramCounter(
    input inc, 
    input PcSel, 
    input[31:0] step, 
    output reg[31:0] count);
    always @(posedge inc) begin
        if (~PcSel) count <= count + 4;
        else count <= count + step;
    end
    
endmodule