module BranchComp (
    input OpA,
    input OpB,
    input BrUn,
    output reg BEq,
    output reg BLT
);
    reg[31:0] diff;
    always @(OpA or OpB or BrUn) begin
        if (~BrUn && A[31] ^ B[31])
            BLT <= A[31];
        else begin
            diff <= A - B;
            BLT <= diff[31];
        end
    end  
endmodule