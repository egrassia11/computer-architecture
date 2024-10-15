`timescale 1ns/1ps

module tb_full_adder;
    reg a, b, cin;
    wire sum, cout;

    // Instantiate the Full Adder
    full_adder uut (
        .a(a),
        .b(b),
        .cin(cin),
        .sum(sum),
        .cout(cout)
    );

    initial begin
        // Monitor signals
        $monitor("a = %b, b = %b, cin = %b, sum = %b, cout = %b", a, b, cin, sum, cout);

        // Test cases
        a = 0; b = 0; cin = 0; #10;
        a = 0; b = 1; cin = 0; #10;
        a = 1; b = 0; cin = 1; #10;
        a = 1; b = 1; cin = 1; #10;

        $finish;
    end
endmodule
