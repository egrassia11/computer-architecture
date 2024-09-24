module register_file (
    input clk, reset,
    input [4:0] read_reg1, read_reg2, write_reg,
    input [31:0] write_data,
    input reg_write,
    output [31:0] read_data1, read_data2
);

reg [31:0] registers [31:0];

always @(posedge clk or posedge reset) begin
    if (reset) begin
        integer i;
        for (i = 0; i < 32; i = i + 1) registers[i] <= 32'b0;
    end else if (reg_write) begin
        registers[write_reg] <= write_data;
    end
end

assign read_data1 = registers[read_reg1];
assign read_data2 = registers[read_reg2];

endmodule

