`define DATA_WIDTH SYM_WIDTH+INT_WIDTH+DEC_WIDTH

module LoopFilter#(
    parameter SYM_WIDTH = 1,
    parameter INT_WIDTH = 1,
    parameter DEC_WIDTH = 14,
    parameter signed [`DATA_WIDTH-1 : 0] C1 = 'sh0106,
    parameter signed [`DATA_WIDTH-1 : 0] C2 = 'sh0246
)(
    input wire clk,
    input wire rstn,
    input wire mk,
    input wire data_ready, //输入数据有效位
    input wire signed [`DATA_WIDTH-1 : 0] LoopFilterInputData,

    output wire data_valid, //输出数据有效位
    output wire signed [`DATA_WIDTH-1 : 0] LoopFilterOutputData
);

    wire [1:0] dataValidShift;
    wire [1:0] dataValidBuffer;
    wire dffEN;
    wire signed [`DATA_WIDTH-1 : 0] LoopFilterBuffer1, LoopFilterBuffer2;
    wire signed [`DATA_WIDTH-1 : 0] culatNum1, culatNum2;

    assign data_valid = dataValidBuffer[0]; //输出数据有效
    assign dataValidShift = {data_ready, dataValidBuffer[1]};
    assign dffEN = data_ready & mk;

    LoopFilterCulate#(
        .SYM_WIDTH(SYM_WIDTH),
        .INT_WIDTH(INT_WIDTH),
        .DEC_WIDTH(DEC_WIDTH)
    )LoopFilterCulate_u1(
        .c1(C1),
        .c2(C2),
        .buffer1(LoopFilterBuffer1),
        .buffer2(LoopFilterBuffer2),
        .inputData(LoopFilterInputData),
        .culatNum1(culatNum1),
        .culatNum2(culatNum2)
    );

    dfflr #(`DATA_WIDTH) dfflr_Buffer1   ( clk, rstn, dffEN, culatNum1, LoopFilterBuffer1);
    dfflr #(`DATA_WIDTH) dfflr_Buffer2   ( clk, rstn, dffEN, LoopFilterBuffer1, LoopFilterBuffer2);
    dffr  #(2)           dfflr_dataValid ( clk, rstn, dataValidShift, dataValidBuffer);

    dfflrc #(`DATA_WIDTH) dfflrc_OutputData ( clk, rstn, dffEN, culatNum2, LoopFilterOutputData);

endmodule