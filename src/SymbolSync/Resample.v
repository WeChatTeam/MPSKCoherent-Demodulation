`define DATA_WIDTH SYM_WIDTH+INT_WIDTH+DEC_WIDTH

module Resample#(
    parameter SYM_WIDTH = 1,
    parameter INT_WIDTH = 1,
    parameter DEC_WIDTH = 14
)(
    input wire clk,
    input wire rstn,
    input wire mk,
    input wire signed [`DATA_WIDTH-1 : 0] ResampleInputDataQ,
    input wire signed [`DATA_WIDTH-1 : 0] ResampleInputDataI,

    output wire signed [`DATA_WIDTH-1 : 0] ResampleOutputDataQ,
    output wire signed [`DATA_WIDTH-1 : 0] ResampleOutputDataI
);

dff #(`DATA_WIDTH) dfflr_OutputQ ( mk, ResampleInputDataQ, ResampleOutputDataQ);
dff #(`DATA_WIDTH) dfflr_OutputI ( mk, ResampleInputDataI, ResampleOutputDataI);

endmodule
