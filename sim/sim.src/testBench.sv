`timescale 1ns/1ps
module testBench;

    parameter DATA_WIDTH = 16;
    integer file_I, file_Q, file_I_OUT, file_Q_OUT;
    integer n = 0, len=100e3;
    reg [DATA_WIDTH-1:0] I_data[0:100000-1];
    reg [DATA_WIDTH-1:0] Q_data[0:100000-1];
    reg clk, rstn;
    reg [DATA_WIDTH-1:0] data_I_IN, data_Q_IN;
    reg [DATA_WIDTH-1:0] data_I_OUT, data_Q_OUT;
    reg data_ready;

    wire mk;

    symbolSync #(
        .SYM_WIDTH(1),
        .INT_WIDTH(1),
        .DEC_WIDTH(14)
    )test(
        .clk(clk),
        .rstn(rstn),
        .data_ready(data_ready),
        .InputDataQ(data_Q_IN),
        .InputDataI(data_I_IN),
        .mk(mk),
        .OutputDataQ(data_Q_OUT),
        .OutputDataI(data_I_OUT)
    );

    initial begin
        file_I = $fopen("D:/WorkSpace/Github/MPSKCoherent-Demodulation/data/I_signal.txt", "r");
        file_Q = $fopen("D:/WorkSpace/Github/MPSKCoherent-Demodulation/data/Q_signal.txt", "r");
        file_I_OUT = $fopen("D:/WorkSpace/Github/MPSKCoherent-Demodulation/data/I_out_signal.txt", "w");
        file_Q_OUT = $fopen("D:/WorkSpace/Github/MPSKCoherent-Demodulation/data/Q_out_signal.txt", "w");
        while (n<=len) begin
            $fscanf(file_I, "%h\n", I_data[n][DATA_WIDTH-1:0]);
            n=n+1;
        end
        n=0;
        while (n<=len) begin
            $fscanf(file_Q, "%h\n", Q_data[n][DATA_WIDTH-1:0]);
            n=n+1;
        end
        $fclose(file_I);
        $fclose(file_Q);
        data_ready=0;
        rstn=1;
        data_Q_IN = 0;
        data_I_IN = 0;
        n=0;
        #5 rstn=0;
        #5 data_ready = 1;
        #5 rstn=1; clk=1; 
        #64000
        data_ready = 0;
        #20
        $fclose(file_I_OUT);
        $fclose(file_Q_OUT);
        $finish;
    end

    always  #1 clk <= ~clk;
    always @(posedge clk) begin
        data_I_IN <= I_data[n][16:0];
        data_Q_IN <= Q_data[n][16:0];
        n=n+1;
    end
    always @(posedge mk) begin
        $fwrite(file_I_OUT, "%d\n", data_I_OUT);
        $fwrite(file_Q_OUT, "%d\n", data_Q_OUT);
    end

endmodule