module tb_barrel_shifter32;
    reg [31:0] data_in;
    reg [4:0] shift_amt;
    reg [1:0] shift_type;
    wire [31:0] data_out;

    barrel_shifter32 uut (.data_in(data_in), .shift_amt(shift_amt), .shift_type(shift_type), .data_out(data_out));

    initial begin
        // Test logical left shift
        data_in = 32'hA5A5A5A5; shift_amt = 5; shift_type = 2'b00;
        #10;

        // Test logical right shift
        shift_amt = 5; shift_type = 2'b01;
        #10;

        // Test arithmetic right shift
        shift_amt = 5; shift_type = 2'b10;
        #10;

        // Test rotate right shift
        shift_amt = 5; shift_type = 2'b11;
        #10;

        $finish;
    end
endmodule

