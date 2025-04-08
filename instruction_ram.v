module instruction_ram (
    input E,
    input [7:0] addr,
    output reg [31:0] data_out
);
	
    (* ram_init_file = "program.mif" *)
    reg [31:0] mem [0:255];

    always @(negedge E) begin
        data_out <= mem[addr];
	 end
		  
endmodule
