`timescale 1ns/1ps

module tb_mux4to1;
    reg [3:0] in;
    reg [1:0] sel;
    wire out;

    // Instantiate the 4 to 1 MUX
    mux4to1 uut (
        .in(in),
        .sel(sel),
        .out(out)
    );

    initial begin
        // Monitor signals
        $monitor("in = %b, sel = %b, out = %b", in, sel, out);

        // Test cases
        in = 4'b0000; sel = 2'b00; #10;
        in = 4'b1010; sel = 2'b01; #10;
        in = 4'b1100; sel = 2'b10; #10;
        in = 4'b1111; sel = 2'b11; #10;

        $finish;
    end
endmodule
