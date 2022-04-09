`define FIXED_DATA_WIDTH SYM_WIDTH+INT_WIDTH+DEC_WIDTH
`define FULL_
`define FixedData(x) {x[SYM_WIDTH+INT_WIDTH*2+DEC_WIDTH*2], x[DEC_WIDTH*2], x[DEC_WIDTH*2-1:DEC_WIDTH]}

module carrierWaveSync #(
    parameter SYM_WIDTH = 1,
    parameter INT_WIDTH = 3,
    parameter DEC_WIDTH = 14,
    parameter signed [`FIXED_DATA_WIDTH-1 : 0] C1 = 'sh0106,
    parameter signed [`FIXED_DATA_WIDTH-1 : 0] C2 = 'sh0246
)(
    input wire clk,
    input wire rstn,
    input wire signed [`FIXED_DATA_WIDTH-1 : 0] signal_I,
    input wire signed [`FIXED_DATA_WIDTH-1 : 0] signal_Q
);

wire isIBiggerZero, isQBiggerZero;
wire signed [`FIXED_DATA_WIDTH-1 : 0] PLL_I, PLL_Q;
wire signed [`FIXED_DATA_WIDTH-1 : 0] Discriminator_Out;
wire signed [`FIXED_DATA_WIDTH-1 : 0] PLL_Phase, PLL_Phase_temp;
wire signed [`FIXED_DATA_WIDTH-1 : 0] PLLFreqPartBuffer, NCO_PhaseBuffer;

assign isIBiggerZero = signal_I > {`FIXED_DATA_WIDTH{1'b0}};
assign isQBiggerZero = signal_Q > {`FIXED_DATA_WIDTH{1'b0}};
assign PLL_I = isIBiggerZero ? signal_I : ~signal_I + 1;
assign PLL_Q = isIBiggerZero ? signal_Q : ~signal_Q + 1;
assign Discriminator_Out = (PLL_I + PLL_Q) >> 2;
assign PLL_Phase_temp = C1 * Discriminator_Out;
assign PLL_Phase = FixedData(PLL_Phase_temp);

dffrc #(`FIXED_DATA_WIDTH) dffrc(clk, rstn, )

endmodule 