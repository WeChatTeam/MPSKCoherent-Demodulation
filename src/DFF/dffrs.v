module dffrs #(
    parameter DATA_WIDTH = 16
)(
    input wire clk,
    input wire rstn,
    input wire [DATA_WIDTH-1 : 0] d,

    output wire [DATA_WIDTH-1 : 0] q
);

reg [DATA_WIDTH-1 : 0] q_r;
assign q = q_r;

always @(posedge clk or negedge rstn) begin
    if(rstn == 1'b0) begin
        q_r <= {DATA_WIDTH{1'b1}};
    end
    else begin
        q_r <= d;
    end
end

endmodule 