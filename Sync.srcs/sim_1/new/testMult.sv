`timescale 1ns / 1ps

module testMult();
reg signed [15:0] a = 'sh0245;
reg signed [15:0] b = 'shEC58;
reg signed [31:0] c;

initial begin
    c = a*b;
    #10 
    $finish;
end

endmodule
