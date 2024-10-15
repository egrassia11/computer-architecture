module tb_register_file;
    reg clk, reset;
    reg [4:0] read_reg1, read_reg2, write_reg;
    reg [31:0] write_data;
    reg reg_write;
    wire [31:0] read_data1, read_data2;

    register_file uut (.clk(clk), .reset(reset), .read_reg1(read_reg1), .read_reg2(read_reg2), .write_reg(write_reg), .write_data(write_data), .reg_write(reg_write), .read_data1(read_data1), .read_data2(read_data2));

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;
        reg_write = 0;
        #10 reset = 0;

        // Write to register 1
        write_reg = 5'b00001; write_data = 32'hDEADBEEF; reg_write = 1;
        #10 reg_write = 0;

        // Read from registers
        read_reg1 = 5'b00001; read_reg2 = 5'b00000;
        #10;

        $finish;
    end
endmodule

