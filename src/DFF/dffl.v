module dffl #(
    parameter DATA_WIDTH = 16
)(
    input wire clk,
    input wire en,
    input wire [DATA_WIDTH-1 : 0] d,

    output wire [DATA_WIDTH-1 : 0] q
);

reg [DATA_WIDTH-1 : 0] q_r;
assign q = q_r;

always @(posedge clk) begin
    if (en == 1'b1) begin
        q_r <= d;
    end
    else begin
        q_r <= q;
    end
end

endmodule 