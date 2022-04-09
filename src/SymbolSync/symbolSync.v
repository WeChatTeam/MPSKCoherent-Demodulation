/*
    定点数位宽为16
    [15] ---> 符号位
    [14] ---> 整数部分
    [13:0] ---> 小数部分
*/
module symbolSync#(
    parameter SYM_WIDTH = 1, //符号位位宽
    parameter INT_WIDTH = 1, //整数部分位宽
    parameter DEC_WIDTH = 14 //小数部分位宽
)(
    input wire clk,
    input wire rstn,
    input wire signed [SYM_WIDTH+INT_WIDTH+DEC_WIDTH-1 : 0] InputDataQ, 
    input wire signed [SYM_WIDTH+INT_WIDTH+DEC_WIDTH-1 : 0] InputDataI, 
    input wire data_ready,

    output wire mk,
    output wire signed [SYM_WIDTH+INT_WIDTH+DEC_WIDTH-1 : 0] OutputDataQ,
    output wire signed [SYM_WIDTH+INT_WIDTH+DEC_WIDTH-1 : 0] OutputDataI
    );

    wire [SYM_WIDTH+INT_WIDTH+DEC_WIDTH-1 : 0] IF2ED_Q, IF2ED_I;
    wire [SYM_WIDTH+INT_WIDTH+DEC_WIDTH-1 : 0] ED2LF;
    wire [SYM_WIDTH+INT_WIDTH+DEC_WIDTH-1 : 0] LF2TC;
    wire [SYM_WIDTH+INT_WIDTH+DEC_WIDTH-1 : 0] uk;
    wire ifDataValid, erDataValid, lfdataValid;

    InterpolatedFilter #(
        .SYM_WIDTH(SYM_WIDTH),
        .INT_WIDTH(INT_WIDTH),
        .DEC_WIDTH(DEC_WIDTH)
    ) InterpolatedFilter_u1(
        .clk(clk),
        .rstn(rstn),
        .data_ready(data_ready),
        .symDataQ(InputDataQ),
        .symDataI(InputDataI),
        .uk(uk),
        .data_valid(ifDataValid),
        .FilterOutputDataQ(IF2ED_Q),
        .FilterOutputDataI(IF2ED_I)
    );
    //-----------------------------------
    ErrDetecer #(
        .SYM_WIDTH(SYM_WIDTH),
        .INT_WIDTH(INT_WIDTH),
        .DEC_WIDTH(DEC_WIDTH)
    )ErrDetecer_u1(
        .clk(clk),
        .rstn(rstn),
        .data_ready(ifDataValid),
        .ErrDetecerInputDataQ(IF2ED_Q),
        .ErrDetecerInputDataI(IF2ED_I),
        .data_valid(erDataValid),
        .ErrDetecerOutputData(ED2LF)
    );
    //-----------------------------------
    LoopFilter #(
        .SYM_WIDTH(SYM_WIDTH),
        .INT_WIDTH(INT_WIDTH),
        .DEC_WIDTH(DEC_WIDTH)
    )LoopFilter_u1(
        .clk(clk),
        .rstn(rstn),
        .mk(mk),
        .data_ready(erDataValid),
        .LoopFilterInputData(ED2LF),
        .data_valid(lfdataValid),
        .LoopFilterOutputData(LF2TC)
    );
    //-----------------------------------
    TimingControl #(
        .SYM_WIDTH(SYM_WIDTH),
        .INT_WIDTH(INT_WIDTH),
        .DEC_WIDTH(DEC_WIDTH)
    )TimingControl_u1(
        .clk(clk),
        .rstn(rstn),
        .mk(mk),
        .data_ready(lfdataValid),
        .TimingControlInputData(LF2TC),
        .uk(uk)
    );
    //-----------------------------------
    Resample #(
        .SYM_WIDTH(SYM_WIDTH),
        .INT_WIDTH(INT_WIDTH),
        .DEC_WIDTH(DEC_WIDTH)
    )Resample_u1(
        .clk(clk),
        .rstn(rstn),
        .mk(mk),
        .ResampleInputDataQ(InputDataQ),
        .ResampleInputDataI(InputDataI),
        .ResampleOutputDataQ(OutputDataQ),
        .ResampleOutputDataI(OutputDataI)
    );
endmodule
