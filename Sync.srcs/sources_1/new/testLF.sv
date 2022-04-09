`timescale 1ns / 1ps

module testLF();

    parameter DATA_WIDTH = 16;
    integer file_LF, file_ED, file_MK, n = 0, len=100e3;
    reg [DATA_WIDTH-1:0] LF[0:100000-1];
    reg [DATA_WIDTH-1:0] ED[0:100000-1];
    reg [DATA_WIDTH-1:0] MK[0:100000-1];
    reg clk, rstn;
    reg [DATA_WIDTH-1:0] ED_IN, LF_IN, MK_IN;
    reg [DATA_WIDTH-1:0] data_OUT;

    LoopFilter #(
        .SYM_WIDTH(1),
        .INT_WIDTH(1),
        .DEC_WIDTH(14)
    )test(
        .clk(clk),
        .rstn(rstn),
        .mk(MK_IN[DATA_WIDTH-2]),
        .LoopFilterInputData(ED_IN),
        .LoopFilterOutputData(data_OUT)
    );

    initial begin
        file_LF = $fopen("C:/Users/Administrator/Desktop/Sync/data/SLFO.txt", "r");
        file_ED = $fopen("C:/Users/Administrator/Desktop/Sync/data/EDO.txt", "r");
        file_MK = $fopen("C:/Users/Administrator/Desktop/Sync/data/mk.txt", "r");
        
        while (n<=len) begin
            $fscanf(file_LF, "%h/n", LF[n][DATA_WIDTH-1:0]);
            $fscanf(file_ED, "%h/n", ED[n][DATA_WIDTH-1:0]);
            $fscanf(file_MK, "%h/n", MK[n][DATA_WIDTH-1:0]);
            n=n+1;
        end
        $fclose(file_LF);
        $fclose(file_ED);

        rstn=1;
        ED_IN = 0;
        LF_IN = 0;
        MK_IN = 0;
        n=0;
        #5 rstn=0;
        #5 rstn=1; clk=0;
        
    end

    always  #1 clk <= ~clk;
    always @(posedge clk) begin
        ED_IN <= ED[n][16:0];
        LF_IN <= LF[n][16:0];
        MK_IN <= MK[n][16:0];
        n=n+1;
    end

endmodule

