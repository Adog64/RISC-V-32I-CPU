module CU(
    input clk, 
    input[31:0] instr,
    input BEq,
    input BLT,
    output reg PcSel, 
    output reg PcInc,
    output reg RegWEn, 
    output reg[4:0] RD,
    output reg[4:0] RS1,
    output reg[4:0] RS2,
    output[31:0] Imm,
    output reg ImmSel,
    output reg BrUn, 
    output reg BSel, 
    output reg ASel,
    output reg[3:0] AluOp,
    output reg WbSel,
    output reg MemWEn);

    reg[4:0] state;
    reg[11:0] immGrab;
    reg immSel
    ImmSE ImmSE(.imm(immGrab), .immSel(immSel), .extdImm(Imm));

    initial begin
        state <= 5'b00001;
    end


    always @(posedge clk) begin
        
        case (state)
            // Instruction Fetch
            5'b00001: begin
                // PC Update
                PcSel <= 0;
                PcInc <= 1;

                RegWEn <= 0;
                MemWEn <= 0;

                // Next state
                state <= state << 1;
            end
            // Instruction Decode
            5'b00010: begin
                // Determin RS1 & RS2
                RS1 <= instr[19:15];
                RS2 <= instr[24:20];

                PcInc <= 0;

                //Define Imm
                case(instr[6:0])
                    7'b0010011: begin   // Define Imm for I-Type instructions
                        immSel <= 0;
                        immGrab <= instr[31:20];
                    end
                    7'b0000011: begin   // Define Imm for Load Instructions
                        immSel <= 0;
                        immGrab <= instr[31:20];
                    end
                    7'b0100011: begin   // Define Imm for S-Type Instructions
                        immSel <= 0;
                        immGrab[11:5] <= instr[31:25];
                        immGrab[4:0] <= instr[11:7];
                    end
                    7'b1100011: begin   // Define Imm for B-Type Instructions
                        immSel <= 1;
                        immGrab[11] <= instr[31];
                        immGrab[10] <= instr[7];
                        immGrab[9:4] <= instr[30:25];
                        immGrab[3:0] <= instr[11:8];
                    end
                endcase

                // RegFile Read
                RegWEn <= 1;

                // Next state
                state <= state << 1;
            end
            // Execute
            5'b00100: begin
                // Define A & B Select
                ASel <= (instr[6:0] == 7'b0000011 || instr[6:0] == 7'b1000011);
                BSel <= ~(instr[6:0] == 7'b0110011);

                // Define ALU_Op and BrUn
                if (instr[6:0] == 7'b0100011 || instr[6:0] == 7'b0000011 || instr[6:0] == 7'b1100011)
                    ALU_Op <= 4'b0000;
                else
                    ALU_Op <= {instr[30], instr[14:12]};
                BrUn <= instr[14:13] == 2'b11;

                // Next State
                state <= state << 1;
            end
            // DMEM R/W
            5'b01000: begin
                MemWEn <= instr[6:0] == 7'b0100011;

                state <= state << 1;
            end
            // Write Back
            5'b10000: begin
                RD <= instr[11:7];
                WbSel <= !(instr[6:0] == 7'b0000011);
                RegWEn <= (instr[6:0] == 7'b0000011 || instr[6:0] == 7'b0110011 || instr[6:0] == 7'b0010011);
                
                // reset state
                state <= 5'b00001;
            end
        endcase
    end
endmodule

module ImmSE (
    input[11:0] imm,
    input immSel
    output reg[31:0] extdImm
);
    always @(imm) begin
        if (imm[11])
            extdImm <= {21'b1_1111_1111_1111_1111_1111, imm[10:0]} << immSel;
        else
            extdImm <= {21'b0, imm[10:0]} << immSel;
    end
endmodule