module alu32 (
    input [31:0] A, B,
    input [3:0] ALUop, // Operation selector
    output reg [31:0] ALU_result,
    output Zero
);

always @(*) begin
    case (ALUop)
        4'b0000: ALU_result = A & B;    // AND
        4'b0001: ALU_result = A | B;    // OR
        4'b0010: ALU_result = A + B;    // ADD
        4'b0110: ALU_result = A - B;    // SUB
        4'b0111: ALU_result = (A < B) ? 1 : 0;  // SLT
        4'b1100: ALU_result = ~(A | B); // NOR
        default: ALU_result = 0;
    endcase
end

assign Zero = (ALU_result == 0);

endmodule

