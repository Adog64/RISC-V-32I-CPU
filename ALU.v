module ALU(input clk, input [31:0]A, input [31:0]B, input [3:0]op, output reg [31:0]result, output reg [4:0]status);
    always @(clk) begin
        case (op)
            4'b0000:    // ADD
                result <= A + B;
            4'b1000:    // SUB
                result <= A - B;
            4'b0111:    // AND
                result <= A & B;
            4'b0110:    // OR
                result <= A | B;
            4'b0100:    // XOR
                result <= A ^ B;
        endcase
        status[0] <= ~result[31] & (A[31] | B[31]); // carry if the MSB of A or B are 1 and the MSB of result is 0
        status[1] <= ^result;                       // odd parity result
        status[2] <= ~(|result);                    // zero result
        status[3] <= result[31];                    // negative result
        status[4] <= (A[31] ~^ B[31]) & (result[31] ^ A[31]); // overflow if input sign bits match
    end
endmodule


