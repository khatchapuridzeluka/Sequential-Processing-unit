module shift_register (
    input clk,
    input rst,
    input load_en,
    input shift_en,
    input [7:0] parallel_in,
    input serial_in,
    output reg [7:0] q
);

    always @(posedge clk) begin
        if (rst)
            q <= 8'b0;
        else if (load_en)
            q <= parallel_in;
        else if (shift_en)
            q <= {serial_in, q[7:1]};  // Right shift
    end
endmodule
