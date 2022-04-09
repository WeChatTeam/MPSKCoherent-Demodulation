`define DATA_WIDTH SYM_WIDTH+INT_WIDTH+DEC_WIDTH

module InterpolatedFilter#(
    parameter SYM_WIDTH = 1,
    parameter INT_WIDTH = 1,
    parameter DEC_WIDTH = 14
)(
    input  wire clk,
    input  wire rstn, //复位，下降沿出发
    input  wire data_ready, //输入数据有效位
    input  wire signed [`DATA_WIDTH-1 : 0] symDataQ, //Q通道输入数据
    input  wire signed [`DATA_WIDTH-1 : 0] symDataI, //I通道输入数据
    input  wire signed [`DATA_WIDTH-1 : 0] uk,       

    output wire data_valid, //输出数据有效位
    output wire signed [`DATA_WIDTH-1 : 0] FilterOutputDataQ, //滤波器Q通道输出数据
    output wire signed [`DATA_WIDTH-1 : 0] FilterOutputDataI  //滤波器I通道输出数据
);

wire [1:0] dataValidShift;
wire [1:0] dataValidBuffer;
wire signed [`DATA_WIDTH-1 : 0] outputTempQ, outputTempI;
wire signed [`DATA_WIDTH-1 : 0] FilterOutputDataQ_r, FilterOutputDataI_r;
wire signed [`DATA_WIDTH-1 : 0] FilterBufferQ1, FilterBufferQ2, FilterBufferQ3, FilterBufferQ4;
wire signed [`DATA_WIDTH-1 : 0] FilterBufferI1, FilterBufferI2, FilterBufferI3, FilterBufferI4;

assign data_valid = dataValidBuffer[0]; //输出数据有效
assign FilterOutputDataQ = FilterOutputDataQ_r;
assign FilterOutputDataI = FilterOutputDataI_r;
assign dataValidShift = {data_ready, dataValidBuffer[1]};

coffCulate #(
    .SYM_WIDTH(SYM_WIDTH),
    .INT_WIDTH(INT_WIDTH),
    .DEC_WIDTH(DEC_WIDTH)
)coffCulate_u1(
    .uk(uk), //16'h3839 = 0.8785
    .BufferQ1(FilterBufferQ1), 
    .BufferQ2(FilterBufferQ2), 
    .BufferQ3(FilterBufferQ3), 
    .BufferQ4(FilterBufferQ4),
    .BufferI1(FilterBufferI1), 
    .BufferI2(FilterBufferI2), 
    .BufferI3(FilterBufferI3), 
    .BufferI4(FilterBufferI4),
    .coffOutputFixedQ(outputTempQ),
    .coffOutputFixedI(outputTempI)
);

dfflr #(`DATA_WIDTH) dfflr_BufferQ1 ( clk, rstn, data_ready, symDataQ, FilterBufferQ1);
dfflr #(`DATA_WIDTH) dfflr_BufferI1 ( clk, rstn, data_ready, symDataI, FilterBufferI1);

dfflr #(`DATA_WIDTH) dfflr_BufferQ4 ( clk, rstn, data_ready, FilterBufferQ3, FilterBufferQ4);
dfflr #(`DATA_WIDTH) dfflr_BufferQ3 ( clk, rstn, data_ready, FilterBufferQ2, FilterBufferQ3);
dfflr #(`DATA_WIDTH) dfflr_BufferQ2 ( clk, rstn, data_ready, FilterBufferQ1, FilterBufferQ2);

dfflr #(`DATA_WIDTH) dfflr_BufferI4 ( clk, rstn, data_ready, FilterBufferI3, FilterBufferI4);
dfflr #(`DATA_WIDTH) dfflr_BufferI3 ( clk, rstn, data_ready, FilterBufferI2, FilterBufferI3);
dfflr #(`DATA_WIDTH) dfflr_BufferI2 ( clk, rstn, data_ready, FilterBufferI1, FilterBufferI2);

dfflr #(`DATA_WIDTH) dfflr_OutputDataQ ( clk, rstn, data_ready, outputTempQ, FilterOutputDataQ_r);
dfflr #(`DATA_WIDTH) dfflr_OutputDataI ( clk, rstn, data_ready, outputTempI, FilterOutputDataI_r);

dffr #(2)           dfflr_dataValid ( clk, rstn, dataValidShift, dataValidBuffer);


endmodule