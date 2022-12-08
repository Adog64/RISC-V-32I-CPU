module Mux2To1 (
    input[31:0] i0,
    input[31:0] i1,
    input sel,
    output reg[31:0] out
);
    always @(sel or i0 or i1) begin
        case (sel)
            0: out <= i0;
            1: out <= i1;
        endcase
    end
endmodule