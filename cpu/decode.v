
`timescale 1us/100ns

// Define opcodes and function codes
`define OP_ARITH      7'b0110011 // R-type
`define OP_ARITH_I    7'b0010011 // I-type
`define OP_LOAD       7'b0000011 // Load
`define OP_STORE      7'b0100011 // Store
`define OP_BRANCH     7'b1100011 // Branch
`define OP_JAL        7'b1101111 // Jump and Link
`define OP_JALR       7'b1100111 // Jump and Link Register
`define OP_LUI        7'b0110111 // Load Upper Immediate
`define OP_AUIPC      7'b0010111 // Add Upper Immediate to PC

// ALU op codes
`define ALU_ADD       3'b000
`define ALU_SUB       3'b001
`define ALU_SLL       3'b010
`define ALU_XOR       3'b100
`define ALU_SRL       3'b101
`define ALU_SRA       3'b110
`define ALU_OR        3'b111
`define ALU_AND       3'b1000

module decode(
    input wire [31:0] in,
    output wire [19:0] imm_u,
    output wire [11:0] imm_i,
    output wire [11:0] imm_s,
    output wire [11:0] imm_b,
    output wire [20:0] imm_j,
    output wire [4:0] rs1, rs2, rd, // Register source and destination
    output reg [2:0] alu_op,        // ALU operation control signal
    output reg branch_sel, mr_sel, mtr_sel, alu_src, rw_sel, mw_sel, // Control signals
    output reg [31:0] ext_imm       // Extended immediate for ALU
);

    // Internal signals
    reg [6:0] opcode;
    reg [9:0] funct;

    // Assign instruction fields to outputs
    assign rd = in[11:7];
    assign rs1 = in[19:15];
    assign rs2 = in[24:20];
    
    // Immediate assignments for different instruction formats
    assign imm_i = in[31:20];
    assign imm_u = in[31:12];
    assign imm_s = {in[11:7], in[31:25]};
    assign imm_b = {in[31], in[7], in[30:25], in[11:8], 1'b0};
    assign imm_j = {in[31], in[19:12], in[20], in[30:21], 1'b0};

    // Opcodes and funct are taken from the instruction
    always @(*) begin
        opcode = in[6:0];
        funct = {in[31:25], in[14:12]};
        
        alu_src    = 1'b0;
        alu_op     = `ALU_ADD;
        branch_sel = 1'b0;
        mr_sel     = 1'b0;
        mtr_sel    = 1'b0;
        mw_sel     = 1'b0;
        rw_sel     = 1'b0;
        ext_imm    = 32'b0;

        case(opcode)
            
            `OP_ARITH: begin
                alu_src = 1'b0;
                rw_sel = 1'b1;
                case(funct)
                    3'b000: alu_op = `ALU_ADD; // ADD
                    3'b001: alu_op = `ALU_SUB; // SUB
                    3'b010: alu_op = `ALU_SLL; // SLL
                    3'b100: alu_op = `ALU_XOR; // XOR
                    3'b101: alu_op = `ALU_SRL; // SRL
                    3'b110: alu_op = `ALU_SRA; // SRA
                    3'b111: alu_op = `ALU_OR;  // OR
                    3'b1000: alu_op = `ALU_AND; // AND
                    default: alu_op = `ALU_ADD; // Default to ADD
                endcase
            end

            // Register-Immediate
            `OP_ARITH_I: begin
                alu_src = 1'b1;
                rw_sel = 1'b1; 
                ext_imm = {{20{imm_i[11]}}, imm_i};
            end

            // Load operation
            `OP_LOAD: begin
                branch_sel = 1'b0;
                mr_sel     = 1'b1;
                mtr_sel    = 1'b1;
                alu_op     = `ALU_ADD;
                alu_src    = 1'b1;
                rw_sel     = 1'b1;
                ext_imm    = {{20{imm_i[11]}}, imm_i};
            end

            // Store operation
            `OP_STORE: begin
                branch_sel = 1'b0;
                mr_sel     = 1'b0;
                mtr_sel    = 1'b0;
                alu_op     = `ALU_ADD;
                mw_sel     = 1'b1;
                alu_src    = 1'b1;
                rw_sel     = 1'b0;
                ext_imm    = {{20{imm_s[11]}}, imm_s};
            end

            // Branch operation
            `OP_BRANCH: begin
                branch_sel = 1'b1;
                alu_src    = 1'b0;
                rw_sel     = 1'b0;
                ext_imm    = {{19{imm_b[11]}}, imm_b};

            end

            // Jump and Link
            `OP_JAL: begin
                alu_src    = 1'b0;
                rw_sel     = 1'b1;
                ext_imm    = {{11{imm_j[20]}}, imm_j};
            end

            // Jump and Link Register
            `OP_JALR: begin
                alu_src    = 1'b0;
                rw_sel     = 1'b1;
                alu_op     = `ALU_ADD;
                ext_imm    = {{20{imm_i[11]}}, imm_i}; // Sign extend immediate
            end

            // Load Upper Immediate
            `OP_LUI: begin
                alu_src = 1'b0;
                rw_sel = 1'b1;
                ext_imm = {imm_u, 12'b0};
            end

            // Add Upper Immediate to PC
            `OP_AUIPC: begin
                alu_src = 1'b0;
                rw_sel = 1'b1;
                ext_imm = {imm_u, 12'b0};
            end
        endcase
    end
endmodule
