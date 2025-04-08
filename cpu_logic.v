module cpu_logic (
	 input clock,
	 input clockEna,
    input reset,
	 output [15:0] short_display
	 //output reg SUCCESSFULL
);

reg E = 0;
reg [7:0] pc;
wire [31:0] instruction;

// logic behind every clock cycle
always @(posedge clock or posedge reset) begin
	if(reset) begin
		E <=0;
		pc <= 8'b0;
	end
	else begin
		E <= ~E;
		if(E) begin
			pc <= nextpc;
		end
	end
end

//00100000001000100000000000000001
// testing the decode part
//always @(posedge clockEna) begin
//	SUCCESSFULL <= (nextpc == 8'b00000010);
//end




// PART 1 ----> FETCHING THE INSTRUCTION FROM MEMORY.
instruction_ram imem (
    .E(E),
    .addr(pc),
    .data_out(instruction)
);

// PART 2 ----> DECODING THE INSTRUCTION
wire [5:0] opc;
wire [4:0] rs, rt, rd, shamt;
wire [5:0] funct;
wire [15:0] imm;
wire [25:0] iindex;

wire [1:0] type;
wire [2:0] optype;

instruction_decod decoder (
    .instruction(instruction),
    .opc(opc),
    .rs(rs),
    .rt(rt),
    .rd(rd),
    .shamt(shamt),
	 .optype(optype),
    .funct(funct),
    .imm(imm),
    .iindex(iindex),
	 .finalType(type)
);

/*
	input pc[7:0],
	input rst,
	input [1:0] type,
	input [5:0] opc,
	input [4:0] rs,rt,rd,shamt,
	input [15:0] imm,
	input [25:0] iindex,
	output reg [7:0] nextpc
	*/

//part 3 execution
wire [7:0] nextpc;

wire [31:0] regvalue;



instruction_execution (
	.clk(clock),
	.pc(pc),
	.rst(reset),
	.type(type),
	.opc(opc),
	.rs(rs),
	.rd(rd),
	.funct(funct),
	.rt(rt),
	.shamt(shamt),
	.imm(imm),
	.iindex(iindex),
	.nextpc(nextpc),
	.regvalue(regvalue)
);

assign short_display = regvalue[15:0];

endmodule
