`define FixedData(x) {x[SYM_WIDTH+INT_WIDTH*2+DEC_WIDTH*2], x[DEC_WIDTH*2], x[DEC_WIDTH*2-1:DEC_WIDTH]}

module ErrDetecerCulate#(
    parameter SYM_WIDTH = 1,
    parameter INT_WIDTH = 1,
    parameter DEC_WIDTH = 14
)(
    input wire signed [SYM_WIDTH+INT_WIDTH+DEC_WIDTH-1 : 0] input1_Q,
    input wire signed [SYM_WIDTH+INT_WIDTH+DEC_WIDTH-1 : 0] input2_Q,
    input wire signed [SYM_WIDTH+INT_WIDTH+DEC_WIDTH-1 : 0] input1_I,
    input wire signed [SYM_WIDTH+INT_WIDTH+DEC_WIDTH-1 : 0] input2_I,

    output wire signed [SYM_WIDTH+INT_WIDTH+DEC_WIDTH-1 : 0] output_Q,
    output wire signed [SYM_WIDTH+INT_WIDTH+DEC_WIDTH-1 : 0] output_I
);

wire signed [SYM_WIDTH+(INT_WIDTH*2)+(DEC_WIDTH*2) : 0] tempQ, tempI;

assign tempQ = input1_Q * input2_Q;
assign tempI = input1_I * input2_I;
assign output_Q = `FixedData(tempQ);
assign output_I = `FixedData(tempI);

endmodule