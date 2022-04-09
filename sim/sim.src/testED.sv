`timescale 1ns / 1ps

module testED;

    parameter DATA_WIDTH = 16;
    integer file_IF_I, file_IF_Q, file_I, file_ED, n = 0, len=100e3;
    reg [DATA_WIDTH-1:0] I_data[0:100000-1];
    reg [DATA_WIDTH-1:0] Q_data[0:100000-1];
    reg [DATA_WIDTH-1:0] IFQ[0:100000-1];
    reg [DATA_WIDTH-1:0] IFI[0:100000-1];
    reg [DATA_WIDTH-1:0] ED[0:100000-1];
    reg clk, rstn;
    reg [DATA_WIDTH-1:0] ED_IN, IF_Q, IF_I;
    reg [DATA_WIDTH-1:0] data_OUT;

    ErrDetecer #(
        .SYM_WIDTH(1),
        .INT_WIDTH(1),
        .DEC_WIDTH(14)
    )test(
        .clk(clk),
        .rstn(rstn),
        .ErrDetecerInputDataQ(IF_Q),
        .ErrDetecerInputDataI(IF_I),
        .ErrDetecerOutputData(data_OUT)
    );

    initial begin
        file_IF_I = $fopen("C:/Users/Administrator/Desktop/Sync/data/I_IFO.txt", "r");
        file_IF_Q = $fopen("C:/Users/Administrator/Desktop/Sync/data/Q_IFO.txt", "r");
        file_ED = $fopen("C:/Users/Administrator/Desktop/Sync/data/EDO.txt", "r");
        
        while (n<=len) begin
            $fscanf(file_IF_I, "%h/n", IFI[n][DATA_WIDTH-1:0]);
            $fscanf(file_IF_Q, "%h/n", IFQ[n][DATA_WIDTH-1:0]);
            $fscanf(file_ED, "%h/n", ED[n][DATA_WIDTH-1:0]);
            n=n+1;
        end
        $fclose(file_IF_I);
        $fclose(file_IF_Q);
        $fclose(file_ED);

        rstn=1;
        ED_IN = 0;
        IF_I = 0;
        IF_Q = 0;
        n=0;
        #5 rstn=0;
        #5 rstn=1; clk=0;
        
    end

    always  #1 clk <= ~clk;
    always @(posedge clk) begin
        ED_IN <= ED[n][16:0];
        IF_I <= IFI[n][16:0];
        IF_Q <= IFQ[n][16:0];
        n=n+1;
    end

endmodule