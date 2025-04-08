module instruction_decod (
	input [31:0] instruction,
	output [5:0] opc,
	output [4:0] rs,
	output [4:0] rt,
	output [4:0] rd,
	output [4:0] shamt,
	output [5:0] funct,
	output [15:0] imm,
	output [25:0] iindex,
	output [1:0] finalType,
	output [2:0] optype
);


function [1:0] Type (input [5:0] opcode);
	casez (opcode)
		6'b000000: Type = 2'b01; // R TYPE INSTRUCTION: OPC IS ALWAYS 0;
		6'b000010, 6'b000011: Type = 2'b10;  // J TYPE INSTRUCTION 2 OPCS
		default: Type = 2'b00;  // all the other valid opcs are I type
	endcase
endfunction

wire [1:0] type;

function [2:0] OPtypeI (input [5:0] opcode);
	casez(opc)
		6'b001000, 6'b001001: OPtypeI = 3'b000; // going into the AU
		6'b001100, 6'b001101, 6'b001110, 6'b001111: OPtypeI = 3'b001; // ALU LOGICAL OPERATIONS
		6'b000001, 6'b000100, 6'b000101, 6'b000110, 6'b000111, 6'b000010, 6'b000011: OPtypeI = 3'b010; //pc change
		6'b100011, 6'b101011: OPtypeI = 3'b011; //lw / sw
		6'b001010, 6'b001011: OPtypeI = 3'b101; // test and set
	endcase
endfunction

// 000 - AU     001 - ALU LOGICAL     010 - PC CHANGE   011 - LW/SW     100 - SHIFT   101 - TEST/SET

function [2:0] OPtypeR(input [5:0] FunctionCode);
	casez(funct)
		6'b000010: OPtypeR = 3'b100; // shifting
		6'b100000,6'b100001,6'b100010,6'b100011: OPtypeR =3'b000;//AU
		6'b100100,6'b100101,6'b100110,6'b100111: OPtypeR =3'b001; // ALU LOGICAL OPS
		6'b101010,6'b101011: OPtypeR =3'b101; // test/set\
		6'b001000,6'b001001: OPtypeR =3'b010; //jump
		6'b001100: OPtypeR =3'b110; //sysc		
	endcase
endfunction

// getting the opcode
assign opc = instruction[31:26];

// getting the type ( I,R,J)
assign type = Type(opc);


// assigning the register values (rs rt rd)
assign rs = (type == 2'b10 ? 5'b00000 : instruction[25:21]);
assign rt = (type == 2'b10 ? 5'b00000 : instruction[20:16]);
assign rd = (type == 2'b01 ? instruction[15:11] : 5'b00000);

// assigning the shift amount (only for the R type)
assign shamt = (type ==2'b01 ? instruction[10:6] : 5'b00000);

// assigning the function code (only for the R type)
assign funct = (type == 2'b01 ? instruction[5:0] : 5'b00000);

//assinging the immediate ( only for i type )
assign imm = (type == 2'b00 ? instruction[15:0] : 16'b0);

//assigning the iindex (only for the j type)
assign iindex = (type == 2'b10 ? instruction[25:0] : 26'b0);


assign finalType = type;

assign optype = (finalType == 2'b00 ? OPtypeI(opc) : OPtypeR(funct));


endmodule

