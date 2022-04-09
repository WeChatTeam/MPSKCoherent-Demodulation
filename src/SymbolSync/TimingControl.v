`define DATA_WIDTH SYM_WIDTH+INT_WIDTH+DEC_WIDTH

module TimingControl#(
    parameter SYM_WIDTH = 1,
    parameter INT_WIDTH = 1,
    parameter DEC_WIDTH = 14,
    parameter signed [`DATA_WIDTH-1 : 0] ONE_DIV_FS_DIV_BAND = 'sh03E3,
    parameter signed [`DATA_WIDTH-1 : 0] ONE = 'sh4000
)(
    input wire clk,
    input wire rstn,
    input wire signed [`DATA_WIDTH-1 : 0] TimingControlInputData,
    input wire data_ready,

    output wire mk,
    output wire signed [`DATA_WIDTH-1 : 0] uk
);

    wire signed [`DATA_WIDTH-1 : 0] TimingControlModData;
    wire signed [INT_WIDTH-1:0] Buffer2int;
    wire signed [`DATA_WIDTH-1 : 0] TimingControlBuffer1;

    wire mkDelay1, mkDelay2, syncPulseStart, ukSatart;
    wire signed [`DATA_WIDTH-1 : 0] TimingControlBuffer2;
    
    assign ukSatart = data_ready & mkDelay2;
    assign syncPulseStart = (TimingControlBuffer2 < TimingControlModData) & data_ready;
    assign Buffer2int = TimingControlBuffer2[`DATA_WIDTH-1 : DEC_WIDTH];
    assign TimingControlBuffer1 = TimingControlModData - TimingControlInputData - ONE_DIV_FS_DIV_BAND;
    assign TimingControlModData =  (Buffer2int >= 0) ? TimingControlBuffer2 : (TimingControlBuffer2 + ONE);

    dfflr #(1)           dfflr_mk        ( clk, rstn, data_ready, mkDelay1, mk);
    dfflr #(1)           dfflr_Delay1    ( clk, rstn, data_ready, mkDelay2, mkDelay1);
    dfflr #(`DATA_WIDTH) dfflr_Buffer2   ( clk, rstn, data_ready, TimingControlBuffer1, TimingControlBuffer2);

    dfflrc #(1)           dfflrc_Delay2   ( clk, rstn, syncPulseStart, 1'b1, mkDelay2);
    dfflrc #(`DATA_WIDTH) dfflrc_uk       ( clk, rstn, ukSatart, TimingControlModData, uk);
    
endmodule