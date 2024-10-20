`timescale 1us/100ns

module early_cpu(in, zero, clk, rst);
    input wire [31:0] in;
    input wire clk, rst;
    output wire zero;

    wire [31:0] ext_imm, rf_do0, rf_do1, alu_do, alu_din1, mr_do, write_data, instr;
    wire [19:0] imm_u;
    wire [11:0] imm_i, imm_j, imm_s, imm_b;
    wire [4:0] rs1, rs2, rd;   // Register addresses
    wire [2:0] alu_func;
    wire rf_we, alu_src, branch_sel, mr_sel, mtr_sel, mw_sel;

    wire [31:0] pc_next, pc_plus_4;
    reg [31:0] pc; // Program Counter

    wire enable_imem = 1'b1;  // Enable instruction memory

    assign pc_plus_4 = pc + 32'd4;

    // PC update logic
    always @(posedge clk or posedge rst) begin
        if (rst)
            pc <= 32'b0;
        else if (branch_sel && zero) 
            pc <= pc + {{19{imm_b[11]}}, imm_b};
        else 
            pc <= pc_plus_4;
    end

    // Instruction memory instantiation
    memory2c imem (
        .data_out(instr),
        .data_in(32'b0),
        .addr(pc),
        .enable(enable_imem),
        .wr(1'b0),
        .createdump(1'b0),
        .clk(clk),
        .rst(rst)
    );

    // Decode logic instantiation
    decode dl(.in(instr), .rs1(rs1), .rs2(rs2), .rd(rd), .imm_i(imm_i),
              .imm_u(imm_u), .imm_j(imm_j), .imm_s(imm_s), .imm_b(imm_b),
              .branch_sel(branch_sel), .mr_sel(mr_sel), .mtr_sel(mtr_sel), 
              .alu_op(alu_func), .alu_src(alu_src), .rw_sel(rf_we), 
              .mw_sel(mw_sel), .ext_imm(ext_imm));

    // Register file instantiation
    register_file rf(
        .clk(clk),
        .reset(rst),
        .read_reg1(rs1),
        .read_reg2(rs2),
        .write_reg(rd),
        .write_data(write_data),
        .reg_write(rf_we),
        .read_data1(rf_do0),
        .read_data2(rf_do1)
    );

    // ALU source mux
    mux2to1 mux_alu_src(
        .a(rf_do1), 
        .b(ext_imm), 
        .sel(alu_src), 
        .out(alu_din1)
    );

    // ALU instantiation
    alu32 alu0(
        .A(rf_do0), 
        .B(alu_din1), 
        .ALUop({1'b0, alu_func}),
        .ALU_result(alu_do),
        .Zero(zero)
    );

    // Data memory instantiation
    memory2c dmem(
        .data_out(mr_do), 
        .data_in(rf_do1), 
        .addr(alu_do), 
        .enable(mr_sel), 
        .wr(mw_sel), 
        .createdump(1'b0), 
        .clk(clk), 
        .rst(rst)
    );

    // Write-back source mux
    mux2to1 mux_dmem_src(
        .a(alu_do), 
        .b(mr_do), 
        .sel(mtr_sel), 
        .out(write_data)
    );

endmodule
