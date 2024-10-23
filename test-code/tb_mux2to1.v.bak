`timescale 1ns/1ps

module tb_mux2to1;
    reg a, b, sel;
    wire out;

    // Instantiate the 2 to 1 MUX
    mux2to1 uut (
        .a(a),
        .b(b),
        .sel(sel),
        .out(out)
    );

    initial begin
        // Monitor signals
        $monitor("a = %b, b = %b, sel = %b, out = %b", a, b, sel, out);

        // Test cases
        a = 0; b = 0; sel = 0; #10;
        a = 0; b = 1; sel = 0; #10;
        a = 1; b = 0; sel = 1; #10;
        a = 1; b = 1; sel = 1; #10;

        $finish;
    end
endmodule
