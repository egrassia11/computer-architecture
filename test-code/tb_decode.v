`timescale 1us/100ns

module tb_decode();
    // Test I/O
    reg [31:0] in;
    wire [31:0] ext_imm;
    wire [19:0] imm_u;
    wire [11:0] imm_i, imm_j, imm_b, imm_s;
    wire [4:0] rd, rs1, rs2;
    wire [2:0] alu_op;
    wire branch_sel, mr_sel, mtr_sel, mw_sel, rw_sel, alu_src;

    // Instantiate the decode module
    decode dl(
        .in(in), 
        .rs1(rs1), 
        .rs2(rs2), 
        .rd(rd), 
        .imm_i(imm_i),
        .imm_u(imm_u), 
        .imm_j(imm_j), 
        .imm_s(imm_s), 
        .imm_b(imm_b),
        .branch_sel(branch_sel), 
        .mr_sel(mr_sel), 
        .mtr_sel(mtr_sel),
        .alu_op(alu_op), 
        .alu_src(alu_src), 
        .rw_sel(rw_sel),
        .mw_sel(mw_sel), 
        .ext_imm(ext_imm)
    );

    initial begin
        // Test case 1: ADD instruction
        in = 32'b0000000_00010_00001_000_00011_0110011;  // ADD x3, x1, x2
        #5;

        // Test case 2: ADDI instruction
        in = 32'b000001100011_00100_000_10000_0010011;
        #5;

        // Test case 3: BEQ instruction
        in = 32'b0000000_00010_00001_000_00001_1100011;
        #5;

        // Test case 4: LUI instruction
        in = 32'b00000000000000000001_00001_0110111;

        $finish;
    end
	
endmodule
