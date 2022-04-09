`define FixedData(x) {x[SYM_WIDTH+INT_WIDTH*2+DEC_WIDTH*2], x[DEC_WIDTH*2], x[DEC_WIDTH*2-1:DEC_WIDTH]}
`define FullData(x) {x[15], x[14], x[14], x[14], x[14:0], 14'd0}

module LoopFilterCulate#(
    parameter SYM_WIDTH = 1,
    parameter INT_WIDTH = 1,
    parameter DEC_WIDTH = 14
)(
    input wire signed [SYM_WIDTH+INT_WIDTH+DEC_WIDTH-1 : 0] c1,
    input wire signed [SYM_WIDTH+INT_WIDTH+DEC_WIDTH-1 : 0] c2,
    input wire signed [SYM_WIDTH+INT_WIDTH+DEC_WIDTH-1 : 0] buffer1,
    input wire signed [SYM_WIDTH+INT_WIDTH+DEC_WIDTH-1 : 0] buffer2,
    input wire signed [SYM_WIDTH+INT_WIDTH+DEC_WIDTH-1 : 0] inputData,

    output wire signed [SYM_WIDTH+INT_WIDTH+DEC_WIDTH-1 : 0] culatNum1,
    output wire signed [SYM_WIDTH+INT_WIDTH+DEC_WIDTH-1 : 0] culatNum2
);

    wire signed [SYM_WIDTH+(INT_WIDTH*2)+(DEC_WIDTH*2) : 0] temp1, temp2, temp3, temp4;

    assign temp1 = c1*inputData;
    assign temp2 = c2*inputData;
    assign temp3 = temp1 + temp4 + `FullData(buffer1);
    assign temp4 = temp2 + `FullData(buffer2);
    assign culatNum2 = `FixedData(temp3);
    assign culatNum1 = `FixedData(temp4);

endmodule