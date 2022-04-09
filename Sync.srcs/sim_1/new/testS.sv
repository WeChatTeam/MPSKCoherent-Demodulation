`timescale 1ns / 1ps
`define a(x,y) x*y;
module testS();

parameter SYM_WIDTH = 1;
parameter INT_WIDTH = 1;
parameter DEC_WIDTH = 14;
//1+6+10
reg signed [SYM_WIDTH+INT_WIDTH+DEC_WIDTH-1:0] a, b;
reg signed [SYM_WIDTH+INT_WIDTH+DEC_WIDTH-1:0] c;
reg signed [SYM_WIDTH+INT_WIDTH*2+DEC_WIDTH*2:0] temp;
reg signed [SYM_WIDTH+INT_WIDTH+DEC_WIDTH-1:0] d;

initial begin
    a = 'sh5000;
    b = 'sh4000;
    d = a-b;
    $finish;
    #2  temp = a*b;
    d = {temp[SYM_WIDTH+INT_WIDTH*2+DEC_WIDTH*2], temp[DEC_WIDTH*2], temp[DEC_WIDTH*2-1:DEC_WIDTH]};

end
endmodule