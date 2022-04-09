`define DATA_WIDTH SYM_WIDTH+INT_WIDTH+DEC_WIDTH

module ErrDetecer#(
    parameter SYM_WIDTH = 1,
    parameter INT_WIDTH = 1,
    parameter DEC_WIDTH = 14
)(
    input wire clk,
    input wire rstn,
    input  wire data_ready, //输入数据有效位
    input wire signed [`DATA_WIDTH-1 : 0] ErrDetecerInputDataQ,
    input wire signed [`DATA_WIDTH-1 : 0] ErrDetecerInputDataI,

    output wire data_valid, //输出数据有效位
    output wire signed [`DATA_WIDTH-1 : 0] ErrDetecerOutputData
);

wire [1:0] dataValidShift;
wire [1:0] dataValidBuffer;
wire signed [`DATA_WIDTH-1 : 0] ErrDetecerOutputDataQ;
wire signed [`DATA_WIDTH-1 : 0] ErrDetecerOutputDataI;
wire signed [`DATA_WIDTH-1 : 0] ErrDetecerOutputDataAdd;
wire signed [`DATA_WIDTH-1 : 0] ErrDetecerBufferQ1, ErrDetecerBufferQ2, ErrDetecerBufferQ3, ErrDetecerBufferQ4, ErrDetecerBufferQ5;
wire signed [`DATA_WIDTH-1 : 0] ErrDetecerBufferI1, ErrDetecerBufferI2, ErrDetecerBufferI3, ErrDetecerBufferI4, ErrDetecerBufferI5;

assign dataValidShift = {data_ready, dataValidBuffer[1]};
assign data_valid = dataValidBuffer[0]; //输出数据有效
assign ErrDetecerOutputDataAdd = ErrDetecerOutputDataQ + ErrDetecerOutputDataI;

ErrDetecerCulate #(
    .SYM_WIDTH(SYM_WIDTH),
    .INT_WIDTH(INT_WIDTH),
    .DEC_WIDTH(DEC_WIDTH)
)ErrDetecerCulate_u1(
    .input1_Q(ErrDetecerBufferQ1 - ErrDetecerBufferQ5),
    .input2_Q(ErrDetecerBufferQ3),
    .output_Q(ErrDetecerOutputDataQ),

    .input1_I(ErrDetecerBufferI1 - ErrDetecerBufferI5),
    .input2_I(ErrDetecerBufferI3),
    .output_I(ErrDetecerOutputDataI)
);

dfflr #(`DATA_WIDTH) dfflr_BufferQ5 ( clk, rstn, data_ready, ErrDetecerBufferQ4, ErrDetecerBufferQ5);
dfflr #(`DATA_WIDTH) dfflr_BufferQ4 ( clk, rstn, data_ready, ErrDetecerBufferQ3, ErrDetecerBufferQ4);
dfflr #(`DATA_WIDTH) dfflr_BufferQ3 ( clk, rstn, data_ready, ErrDetecerBufferQ2, ErrDetecerBufferQ3);
dfflr #(`DATA_WIDTH) dfflr_BufferQ2 ( clk, rstn, data_ready, ErrDetecerBufferQ1, ErrDetecerBufferQ2);
dfflr #(`DATA_WIDTH) dfflr_BufferQ1 ( clk, rstn, data_ready, ErrDetecerInputDataQ, ErrDetecerBufferQ1);

dfflr #(`DATA_WIDTH) dfflr_BufferI5 ( clk, rstn, data_ready, ErrDetecerBufferI4, ErrDetecerBufferI5);
dfflr #(`DATA_WIDTH) dfflr_BufferI4 ( clk, rstn, data_ready, ErrDetecerBufferI3, ErrDetecerBufferI4);
dfflr #(`DATA_WIDTH) dfflr_BufferI3 ( clk, rstn, data_ready, ErrDetecerBufferI2, ErrDetecerBufferI3);
dfflr #(`DATA_WIDTH) dfflr_BufferI2 ( clk, rstn, data_ready, ErrDetecerBufferI1, ErrDetecerBufferI2);
dfflr #(`DATA_WIDTH) dfflr_BufferI1 ( clk, rstn, data_ready, ErrDetecerInputDataI, ErrDetecerBufferI1);

dfflr #(`DATA_WIDTH) dfflr_OutputData ( clk, rstn, data_ready, ErrDetecerOutputDataAdd, ErrDetecerOutputData);

dffr #(2)           dfflr_dataValid ( clk, rstn, dataValidShift, dataValidBuffer);

endmodule