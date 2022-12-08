module CPU (
    input clk,
    input rst,
    output[7:0] seg_faults,
    output[31:0] Q10,
    output[4:0] AluStatus
);
    wire[4:0] Q0, Q1, Q2;
    wire[11:0] Q4;
    wire[31:0] Q5, Q6, Q7, Q8, Q9, Q11, Q12, Q13, Q14, Q15, Q16, instr;
    wire ImmSel, BrUn, BEq, BLT, BSel, ASel, WbSel, MemRW, RegWEn, PcInc, PcSel;
    wire[3:0] AluOp;

    ProgramCounter programCounter(.inc(PcInc), .PcSel(PcSel), .step(Q13), .count(Q14));
    ROM iMem(.clk(clk), .rst(rst), .addr(Q14), .dout(instr));
    ALU alu(.op(AluOp), .A(Q8), .B(Q9), .result(Q10), .status(AluStatus));
    RAM dMem(.clk(clk), .rst(rst), .addr(Q10), .din(Q7), .write_en(MemRW), .data_out(Q11), .seg_faults(SegFaults));
    RegFile regFile(.clk(clk), .rst(rst), .write(RegWEn), .rd(Q0), .rs1(Q1), .rs2(Q2), .data_in(Q12), .rs1_out(Q6), .rs2_out(Q7));
    BranchComp branchComp(.OpA(Q6), .OpB(Q7), .BrUn(BrUn), .BEq(BEq), .BLT(BLT));
    CU controlUnit(.clk(clk), .instr(instr), .BEq(BEq), .BLT(BLT), 
                   .PcSel(PcSel), .PcInc(PcInc), .RegWEn(RegWEn), .RD(Q0), .RS1(Q1), .RS2(Q2),
                   .Imm(Q5), .ImmSel(ImmSel), .BrUn(BrUn), .BSel(BSel), .ASel(ASel), .AluOp(AluOp),
                   .WbSel(WbSel), .MemRW(MemRW));

    // control line muxes
    Mux2To1 opASelect(.I0(Q6), .I1(Q14), .sel(ASel), .out(Q8));
    Mux2To1 opBSelect(.I0(Q7), .I1(Q5), .sel(BSel), .out(Q9));
    Mux2To1 writeBackSelect(.I0(Q11), .I1(Q10), .sel(WbSel), .out(Q12));
endmodule