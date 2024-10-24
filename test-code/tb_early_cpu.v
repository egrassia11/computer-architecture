
`timescale 1us/100ns

module tb_early_cpu;
    // Input instruction
    reg clk, rst;      
    reg [31:0] instruction; // Declare instruction as a 32-bit reg
    wire zero;    

    // Instantiate the CPU
    early_cpu cpu_inst(
        .in(instruction),
        .zero(zero),
        .clk(clk),
        .rst(rst)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        // Initialize clock and reset
        clk = 0;
        rst = 1;

        // Reset the CPU
        #10 rst = 0;

        // Test 1: Load Immediate Instruction (LUI)
        instruction = 32'b00000000000000000001000010110111;
        #20;

        // Test 2: Add Instruction (ADD rd = rs1 + rs2)
        instruction = 32'b00000000100000010000001000110011;
        #20;

        // Test 3: Branch Instruction (BEQ)
        instruction = 32'b00000000000100001000000001100011;
        #20;

        // Test 4: Store Word Instruction (SW)
        instruction = 32'b00000000001000001010001000100011;
        #20;

        // Test 5: Load Word Instruction (LW)
        instruction = 32'b00000000010000001000001010000011;
        #20;

        $finish;
    end

endmodule
