`define FixedData(x) {x[SYM_WIDTH+INT_WIDTH*2+DEC_WIDTH*2], x[DEC_WIDTH*2], x[DEC_WIDTH*2-1:DEC_WIDTH]}
`define DIFF_1_6 'sh0AA9 // 0.167
`define DIFF_1_2 'sh2000 // 0.500
`define DIFF_1_3 'sh1555 // 0.333
`define ONE      'sh4000  // 1.000
/*
    coff1_1Fixed = (1/6)*uk
    ukSquareFixed = uk^2
    coff2_1Fixed = (1/2)*uk^2
    coff2_2Fixed = coff2_1Fixed*(1-uk)
*/
module coffCulate #(
    parameter SYM_WIDTH = 1,
    parameter INT_WIDTH = 2,
    parameter DEC_WIDTH = 5
)(
    input wire signed [SYM_WIDTH+INT_WIDTH+DEC_WIDTH-1 : 0] uk,
    input wire signed [SYM_WIDTH+INT_WIDTH+DEC_WIDTH-1 : 0] BufferQ1, BufferQ2, BufferQ3, BufferQ4,
    input wire signed [SYM_WIDTH+INT_WIDTH+DEC_WIDTH-1 : 0] BufferI1, BufferI2, BufferI3, BufferI4, 

    output wire signed [SYM_WIDTH+INT_WIDTH+DEC_WIDTH-1 : 0] coffOutputFixedQ,
    output wire signed [SYM_WIDTH+INT_WIDTH+DEC_WIDTH-1 : 0] coffOutputFixedI
);

wire signed [SYM_WIDTH+INT_WIDTH+DEC_WIDTH-1 : 0] coff1_1Fixed;
wire signed [SYM_WIDTH+INT_WIDTH+DEC_WIDTH-1 : 0] coff1_2Fixed;
wire signed [SYM_WIDTH+INT_WIDTH+DEC_WIDTH-1 : 0] ukSquareFixed;
wire signed [SYM_WIDTH+INT_WIDTH+DEC_WIDTH-1 : 0] coff2_1Fixed;
wire signed [SYM_WIDTH+INT_WIDTH+DEC_WIDTH-1 : 0] coff2_2Fixed;
wire signed [SYM_WIDTH+INT_WIDTH+DEC_WIDTH-1 : 0] coff3_1Fixed;
wire signed [SYM_WIDTH+INT_WIDTH+DEC_WIDTH-1 : 0] coff3_2Fixed;
wire signed [SYM_WIDTH+INT_WIDTH+DEC_WIDTH-1 : 0] coff4_1Fixed;
wire signed [SYM_WIDTH+INT_WIDTH+DEC_WIDTH-1 : 0] coff4_2Fixed;
wire signed [SYM_WIDTH+INT_WIDTH+DEC_WIDTH-1 : 0] coff1_Fixed;
wire signed [SYM_WIDTH+INT_WIDTH+DEC_WIDTH-1 : 0] coff2_Fixed;
wire signed [SYM_WIDTH+INT_WIDTH+DEC_WIDTH-1 : 0] coff3_Fixed;
wire signed [SYM_WIDTH+INT_WIDTH+DEC_WIDTH-1 : 0] coff4_Fixed;
//test
wire signed [SYM_WIDTH+INT_WIDTH+DEC_WIDTH-1 : 0] q1,q2,q3, q4, i1, i2, i3, i4;

wire signed [SYM_WIDTH+(INT_WIDTH*2)+(DEC_WIDTH*2) : 0] coff1_1Full;
wire signed [SYM_WIDTH+(INT_WIDTH*2)+(DEC_WIDTH*2) : 0] ukSquareFull;
wire signed [SYM_WIDTH+(INT_WIDTH*2)+(DEC_WIDTH*2) : 0] coff2_1Full;
wire signed [SYM_WIDTH+(INT_WIDTH*2)+(DEC_WIDTH*2) : 0] coff2_2Full;
wire signed [SYM_WIDTH+(INT_WIDTH*2)+(DEC_WIDTH*2) : 0] coff3_1Full;
wire signed [SYM_WIDTH+(INT_WIDTH*2)+(DEC_WIDTH*2) : 0] coff3_2Full;
wire signed [SYM_WIDTH+(INT_WIDTH*2)+(DEC_WIDTH*2) : 0] coff4_1Full;
wire signed [SYM_WIDTH+(INT_WIDTH*2)+(DEC_WIDTH*2) : 0] coff4_2Full;
wire signed [SYM_WIDTH+(INT_WIDTH*2)+(DEC_WIDTH*2) : 0] Q1Full, Q2Full, Q3Full, Q4Full;
wire signed [SYM_WIDTH+(INT_WIDTH*2)+(DEC_WIDTH*2) : 0] I1Full, I2Full, I3Full, I4Full;
wire signed [SYM_WIDTH+(INT_WIDTH*2)+(DEC_WIDTH*2) : 0] coff1_Full;

assign coff1_1Full  = `DIFF_1_6*uk;
assign ukSquareFull = uk*uk;
assign coff2_1Full  = `DIFF_1_2*ukSquareFixed;
assign coff2_2Full  = coff2_1Fixed*(`ONE-uk);
assign coff3_1Full  = `DIFF_1_2*uk;
assign coff3_2Full  = coff3_1Fixed*(ukSquareFixed-`ONE);
assign coff4_1Full  = `DIFF_1_3*uk;
assign coff4_2Full  = coff2_1Fixed*(`ONE-coff4_1Fixed);
assign Q1Full       = coff1_Fixed*BufferQ1;
assign Q2Full       = coff2_Fixed*BufferQ2;
assign Q3Full       = coff3_Fixed*BufferQ3;
assign Q4Full       = coff4_Fixed*BufferQ4;
assign I1Full       = coff1_Fixed*BufferI1;
assign I2Full       = coff2_Fixed*BufferI2;
assign I3Full       = coff3_Fixed*BufferI3;
assign I4Full       = coff4_Fixed*BufferI4;


assign coff1_1Fixed  = `FixedData(coff1_1Full);
assign ukSquareFixed = `FixedData(ukSquareFull);
assign coff2_1Fixed  = `FixedData(coff2_1Full);
assign coff2_2Fixed  = `FixedData(coff2_2Full);
assign coff3_1Fixed  = `FixedData(coff3_1Full);
assign coff3_2Fixed  = `FixedData(coff3_2Full);
assign coff4_1Fixed  = `FixedData(coff4_1Full);
assign coff4_2Fixed  = `FixedData(coff4_2Full);
assign coff1_Fixed   = `FixedData(coff1_Full);

assign coff1_2Fixed = ukSquareFixed - `ONE;
assign coff1_Full = coff1_1Fixed * coff1_2Fixed;
assign coff2_Fixed = coff2_2Fixed + uk;
assign coff3_Fixed = coff3_2Fixed - coff1_2Fixed;
assign coff4_Fixed = coff4_2Fixed - coff4_1Fixed;
assign coffOutputFixedQ = `FixedData(Q1Full) + `FixedData(Q2Full) + `FixedData(Q3Full) + `FixedData(Q4Full);
assign coffOutputFixedI = `FixedData(I1Full) + `FixedData(I2Full) + `FixedData(I3Full) + `FixedData(I4Full);
//test
assign q1 = `FixedData(Q1Full);
assign q2 = `FixedData(Q2Full);
assign q3 = `FixedData(Q3Full);
assign q4 = `FixedData(Q4Full);

endmodule