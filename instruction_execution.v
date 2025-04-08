module instruction_execution (
	input clk,
	input [7:0] pc,
	input rst,
	input [1:0] type,
	input [5:0] opc,
	input [4:0] rs,
	input [4:0] rt,
	input [4:0] rd,
	input [5:0] funct,
	input [4:0] shamt,
	input [15:0] imm,
	input [25:0] iindex,
	output reg [7:0] nextpc,
	output reg [31:0] regvalue
);

reg [31:0] registers[0:31];
integer i;

always @(posedge clk or posedge rst) begin
	if( rst ) begin
		for( i = 1; i <32; i=i+1)
			registers[i] <= 32'b0;

		regvalue<=0;
		nextpc<=0;
	end
	else begin
		if( type == 2'b00) begin
			casez(opc)
				6'b001001:
					begin
						registers[rt] <= registers[rs] + imm;
						regvalue <= registers[rt];
						nextpc <= pc + 1;
					end
			endcase
		end
		end


end


endmodule 