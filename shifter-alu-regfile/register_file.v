
`timescale 1us/1ps

module register_file (
    input wire clk,
    input wire reset,
    input wire [4:0] read_reg1, read_reg2, write_reg,
    input wire [31:0] write_data,
    input wire reg_write,
    output wire [31:0] read_data1, read_data2
);

    reg [31:0] registers [0:31];
    integer i;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < 32; i = i + 1) begin
                registers[i] <= 32'b0;
            end
        end else if (reg_write && write_reg != 5'b0) begin
            registers[write_reg] <= write_data;
        end
    end

    assign read_data1 = registers[read_reg1];
    assign read_data2 = registers[read_reg2];

endmodule
