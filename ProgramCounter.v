module ProgramCounter(
    input inc, 
    input rst,
    input PcSel, 
    input[31:0] step, 
    output reg[31:0] count);
    always @(posedge inc or rst) begin
        if (rst) count <= 0;
        else begin
            if (~PcSel) count <= count + 4;
            else count <= count + step;
        end
    end
    
endmodule