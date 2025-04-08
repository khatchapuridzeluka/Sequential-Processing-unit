module tb_shift_register;
    reg clk, rst, load_en, shift_en, serial_in;
    reg [7:0] parallel_in;
    wire [7:0] q;

    shift_register uut (
        .clk(clk),
        .rst(rst),
        .load_en(load_en),
        .shift_en(shift_en),
        .parallel_in(parallel_in),
        .serial_in(serial_in),
        .q(q)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        clk = 0; rst = 1; load_en = 0; shift_en = 0; serial_in = 0; parallel_in = 8'b0;
        #10 rst = 0;

        // Load parallel value
        #10 parallel_in = 8'b10101010;
        load_en = 1;
        #10 load_en = 0;

        // Start shifting
        shift_en = 1;
        serial_in = 1;
        #50;

        // Stop shifting
        shift_en = 0;
        #10 $stop;
    end
endmodule
