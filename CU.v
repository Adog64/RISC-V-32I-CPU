module CU(
    input clk, 
    input[31:0] instr, 
    output reg PcSel, 
    output reg RegWEn, 
    output reg ImmSel, 
    output reg BSel, 
    output reg ASel, 
    output reg[3:0] AluOp);
    always @(posedge clk) begin
        case (instr[6:0])
            7'b0110011: // R-Type instructions
                ALU_Op <= {instr[30], instr[14:12]};
                b_sel <= 0;
                imm_sel <= 0;
            7'b0010011: // I-Type instructions
                ALU_Op <= {1'b0, instr[14:12]};
                b_sel <= 1;
                imm_sel <= 1;
            7'b0000011: // Load instructions
                ALU_OP <= 5'b00000;
            7'b0100011: // Store instructions
                ALU_OP <= 5'b00000;
            7'b1100011: // Branch instructions
        endcase
    end
endmodule

module ImmSE (
    input[11:0] imm,
    output reg[31:0] op
);
    always @(imm) begin
        if (imm[11])
            op <= {21'b1_1111_1111_1111_1111_1111, imm[10:0]};
        else
            op <= {21'b0, imm[10:0]};
    end
endmodule