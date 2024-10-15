`timescale 1us/100ns

module early_cpu(in, zero, clk, rst);
    input wire [31:0] in;
    input wire clk, rst;
    output wire zero;

    wire [31:0] ext_imm, rf_do0, rf_do1, alu_do, alu_din1, mr_do, write_data;
    wire [19:0] imm_u;
    wire [11:0] imm_i, imm_j, imm_s, imm_b;
    wire [4:0] ra0, ra1, wa;
    wire [2:0] alu_func;
    wire rf_we, alu_src, branch_sel, mr_sel, mtr_sel, mw_sel;

    decode dl(.in(in), .rs1(ra0), .rs2(ra1), .rd(wa), .imm_i(imm_i),
              .imm_u(imm_u), .imm_j(imm_j), .imm_s(imm_s), .imm_b(imm_b),
              .branch_sel(branch_sel), .mr_sel(mr_sel), .mtr_sel(mtr_sel), 
              .alu_op(alu_func), .alu_src(alu_src), .rw_sel(rf_we), 
              .mw_sel(mw_sel), .ext_imm(ext_imm));
              
    register_file rf(.ra0(ra0), .ra1(ra1), .we(rf_we), .wd(write_data), 
                     .wa(wa), .out0(rf_do0), .out1(rf_do1), 
                     .clock(clk), .reset(rst));

    alu alu0(.in0(rf_do0), .in1(alu_din1), .selector(alu_func), 
             .zero(zero), .out0(alu_do));


    memory2c dmem(.data_out(mr_do), .data_in(rf_do1), .addr(alu_do), 
                  .enable(mr_sel), .wr(mw_sel), .createdump(1'b0), 
                  .clk(clk), .rst(rst));

    mux_2to1 mux_alu_src(.A(rf_do1), .B(ext_imm), .S0(alu_src), .Z(alu_din1));

    mux_2to1 mux_dmem_src(.A(alu_do), .B(mr_do), .S0(mtr_sel), .Z(write_data));

    reg [31:0] pc;
    always @(posedge clk or posedge rst) begin
        if (rst)
            pc <= 32'b0;  // Reset PC to 0
        else if (branch_sel && zero) 
            pc <= pc + {{19{imm_b[11]}}, imm_b};  // Conditional branch if zero flag is set
        else 
            pc <= pc + 4;  // Default to next instruction
    end

endmodule
