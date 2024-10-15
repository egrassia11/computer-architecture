module tb_alu;
    reg [31:0] A, B;
    reg [3:0] ALUop;
    wire [31:0] ALU_result;
    wire Zero;

    alu32 uut (.A(A), .B(B), .ALUop(ALUop), .ALU_result(ALU_result), .Zero(Zero));

    initial begin
        // Test AND
        A = 32'hA5A5A5A5; B = 32'h5A5A5A5A; ALUop = 4'b0000;
        #10;

        // Test OR
        ALUop = 4'b0001;
        #10;

        // Test ADD
        ALUop = 4'b0010;
        #10;

        // Test SUB
        ALUop = 4'b0110;
        #10;

        // Test SLT
        ALUop = 4'b0111;
        #10;

        // Test NOR
        ALUop = 4'b1100;
        #10;

        $finish;
    end
endmodule

