module ROM(input clk, input rst, input [31:0]addr, output reg[31:0] dout);
    reg [8:0]mem[256:0];
    integer  i;

    always @(posedge clk) begin
        if(rst) begin
            for (i = 0; i < 256; i = i + 1)
                mem[i] <= 0;
            mem[3] <= 32;
            mem[7] <= 42;
            mem[11] <= 69;
        end
        if (addr < 253)
            dout <= {mem[addr[7:0]], mem[addr[7:0] + 1], mem[addr[7:0] + 2], mem[addr[7:0] + 3]};
        else begin
            case (addr)
                253: dout <= {mem[addr[7:0]], mem[addr[7:0] + 1], mem[addr[7:0] + 2], 8'b0};
                254: dout <= {mem[addr[7:0]], mem[addr[7:0] + 1], 16'b0};
                255: dout <= {mem[addr[7:0]], 24'b0};
            endcase
        end
    end
endmodule