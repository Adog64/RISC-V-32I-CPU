module MemChip (
    input clk,
    input rst,
    input enable,
    input[7:0] addr,
    input[31:0] din,
    input write_en,
    output reg[31:0] dout,
    output reg seg_fault
);
    reg [8:0]mem[256:0];
    integer i;

    always @(posedge clk) begin
        if (rst) begin
            for (i = 0; i < 256; i = i + 1)
                mem[i] <= 8'b0;
        end
        else begin    
            if (enable) begin
                if (write_en) begin
                    if (addr < 253) begin
                        mem[addr] <= din[31:24];
                        mem[addr+1] <= din[22:16];
                        mem[addr+2] <= din[15:8];
                        mem[addr+3] <= din[7:0];
                        seg_fault <= 0;
                    end 
                    else begin
                        case (addr)
                            253: begin
                                mem[addr] <= din[31:24];
                                mem[addr+1] <= din[22:16];
                                mem[addr+2] <= din[15:8];
                            end
                            254: begin
                                mem[addr] <= din[31:24];
                                mem[addr+1] <= din[22:16];
                            end
                            255: begin
                                mem[addr] <= din[31:24];
                            end
                        endcase
                        seg_fault <= 1;
                    end
                end else begin
                    if (addr < 253)
                        dout <= {mem[addr], mem[addr + 1], mem[addr + 2], mem[addr + 3]};
                    else begin
                        case (addr)
                            253: dout <= {mem[253], mem[254], mem[255], 8'b0};
                            254: dout <= {mem[254], mem[255], 16'b0};
                            255: dout <= {mem[255], 24'b0};
                        endcase
                    end
                end
            end
        end
    end
    
endmodule

module RAM (
    input clk,
    input rst,
    input[31:0] addr,
    input[31:0] din,
    input write_en,
    output reg[31:0] dout,
    output reg[7:0] seg_faults
);

    wire[7:0] en_sel;
    wire[31:0] douts[7:0];
    MemChip mem0(.clk(clk), .rst(rst), .enable(en_sel[0]), .addr(addr[7:0]), .din(din), .write_en(write_en), .dout(douts[0]), .seg_fault(seg_faults[0]));
    MemChip mem1(.clk(clk), .rst(rst), .enable(en_sel[1]), .addr(addr[7:0]), .din(din), .write_en(write_en), .dout(douts[1]), .seg_fault(seg_faults[1]));
    MemChip mem2(.clk(clk), .rst(rst), .enable(en_sel[2]), .addr(addr[7:0]), .din(din), .write_en(write_en), .dout(douts[2]), .seg_fault(seg_faults[2]));
    MemChip mem3(.clk(clk), .rst(rst), .enable(en_sel[3]), .addr(addr[7:0]), .din(din), .write_en(write_en), .dout(douts[3]), .seg_fault(seg_faults[3]));
    MemChip mem4(.clk(clk), .rst(rst), .enable(en_sel[4]), .addr(addr[7:0]), .din(din), .write_en(write_en), .dout(douts[4]), .seg_fault(seg_faults[4]));
    MemChip mem5(.clk(clk), .rst(rst), .enable(en_sel[5]), .addr(addr[7:0]), .din(din), .write_en(write_en), .dout(douts[5]), .seg_fault(seg_faults[5]));
    MemChip mem6(.clk(clk), .rst(rst), .enable(en_sel[6]), .addr(addr[7:0]), .din(din), .write_en(write_en), .dout(douts[6]), .seg_fault(seg_faults[6]));
    MemChip mem7(.clk(clk), .rst(rst), .enable(en_sel[7]), .addr(addr[7:0]), .din(din), .write_en(write_en), .dout(douts[7]), .seg_fault(seg_faults[72]));
    Decoder3to8 decoder(.select(addr[10:8]), .one_hot(en_sel));
    always @(addr, write_en, 
    douts[0], douts[1], douts[2], douts[3],
    douts[4], douts[5], douts[6], douts[7]) begin
        dout <= douts[addr[10:8]];
    end
endmodule

module Decoder3to8 (
    input[2:0] select,
    output reg[7:0]one_hot
);
    always @(select) begin
        one_hot <= 8'b0000_0001 << select;
    end
endmodule