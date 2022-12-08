// 3 read ops [rs1, rs2]x3
// 3 write ops [rd, int]x3

// module RegFile(input clk, input rst, input r, input [4:0]rd, input [4:0]rs2, input [4:0]rs1, input [31:0]din, output reg [31:0]rs1v, output reg [31:0]rs2v);
//     // 32, 32-bit 
//     reg[31:0] mem [31:0];

//     integer i;

//     always @(posedge clk) begin
//         if (rst) begin
//             for(i = 0; i < 32; i = i + 1)
//                 mem[i] <= 0;
//         end
//         else begin
//             if (r) begin
//                 rs1v <= mem[rs1];
//                 rs2v <= mem[rs2];
//             end
//             else
//                 mem[rd] <= din;
//         end
//     end
// endmodule

module RegFile(clk, rst, rd, rs1, rs2, data_in, read, rs1_out, rs2_out);
    input clk, rst, write;
    input[4:0] rd, rs1, rs2;
    input[31:0] data_in;

    output reg[31:0] rs1_out, rs2_out;

    reg[31:0] memory[31:0];
    integer i;

    always @(posedge clk) begin
        if (rst) begin
            for (i = 0; i < 32; i = i + 1)
                memory[i] = 0;
        end
        else begin
            if (!write) begin
                rs1_out = memory[rs1];
                rs2_out = memory[rs2];
            end
            else begin
                memory[rd] = data_in;
                rs1_out = 0;
                rs2_out = 0;
            end
        end
    end
endmodule