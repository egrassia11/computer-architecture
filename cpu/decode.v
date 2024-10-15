`timescale 1us/100ns

module decode(
    input wire [31:0] in,
    output wire [19:0] imm_u,
    output wire [11:0] imm_i,
    output wire [11:0] imm_s,
    output wire [11:0] imm_j,
    output wire [4:0] rs1, rs2, rd, // Register source and destination
    output reg [2:0] alu_op,     // ALU operation control signal
    output reg branch_sel, mr_sel, mtr_sel, alu_src, rw_sel, mw_sel, // Control signals
    output reg [31:0] ext_imm    // Extended immediate for ALU
);

    // Internal signals
    reg [6:0] opcode;   // Opcode from the instruction
    reg [9:0] funct;    // Funct field
    
    // Assign instruction fields to outputs
    assign rd = in[11:7];
    assign rs1 = in[19:15];
    assign rs2 = in[24:20];
    
    // Immediate assignments for different instruction formats
    assign imm_i = in[31:20];
    assign imm_u = in[31:12];
    assign imm_s = {in[11:7], in[31:25]};
    assign imm_b = {in[31], in[7], in[30:25], in[11:8]};
    assign imm_j = {in[31], in[19:12], in[20], in[30:21]};

    // Opcodes and funct are taken from the instruction
    always @(*) begin
        opcode = in[6:0];
        funct = {in[31:25], in[14:12]};
        
        // Default signal assignments to avoid latches
        alu_src    = 1'b0;
        alu_op     = 3'b000;
        branch_sel = 1'b0;
        mr_sel     = 1'b0;
        mtr_sel    = 1'b0;
        mw_sel     = 1'b0;
        rw_sel     = 1'b0;
        ext_imm    = 32'b0;

        case(opcode)
            // Arithmetic
            `arithmetic_base: begin
                alu_src = 1'b0;
                rw_sel = 1'b1;
            end

            // Register-Immediate
            `arithmetic_imm: begin
                alu_src = 1'b1;
                rw_sel = 1'b1; 
                ext_imm = {{20{imm_i[11]}}, imm_i};
            end

            // Load operation
            `load: begin
                branch_sel = 1'b0;
                mr_sel     = 1'b1;
                mtr_sel    = 1'b1;
                alu_op     = `add;
                alu_src    = 1'b1;
                rw_sel     = 1'b1;
                ext_imm    = {{20{imm_i[11]}}, imm_i};
            end

            // Store operation
            `store: begin
                branch_sel = 1'b0;
                mr_sel     = 1'b0;
                mtr_sel    = 1'b0;
                alu_op     = `add;
                mw_sel     = 1'b1;
                alu_src    = 1'b1;
                rw_sel     = 1'b0;
                ext_imm    = {{20{imm_s[11]}}, imm_s};
            end

            default: begin
                alu_src    = 1'b0;
                alu_op     = `add;
                branch_sel = 1'b0;
                mr_sel     = 1'b0;
                mtr_sel    = 1'b0;
                mw_sel     = 1'b0;
                rw_sel     = 1'b0;
                ext_imm    = 32'b0;
            end
        endcase

        // Handle arithmetic operation types based on funct
        if ((opcode == `arithmetic_base) || (opcode == `arithmetic_imm)) begin
            branch_sel = 1'b0;
            mr_sel     = 1'b0;
            mtr_sel    = 1'b0;
            mw_sel     = 1'b0;
            rw_sel     = 1'b1;

            // Sign extend the immediate for arithmetic immediate instructions
            ext_imm = {{20{imm_i[11]}}, imm_i};

            // ALU operation selection based on funct
            case(funct)
                `ADD:    alu_op = `add;
                `SUB:    alu_op = `sub;
                `SLL:    alu_op = `sll;
                `XOR:    alu_op = `xor;
                `SRL:    alu_op = `srl;
                `SRA:    alu_op = `sra;
                `OR:     alu_op = `or;
                `AND:    alu_op = `and;
                default: alu_op = `add;
            endcase

            // Logical operations don't require sign extension
            if (~(funct == `ADD || funct == `SUB)) begin
                ext_imm = {20'b0, imm_i};
            end
        end
    end
endmodule
