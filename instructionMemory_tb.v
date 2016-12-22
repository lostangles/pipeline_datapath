`timescale 1ns/1ps
`include "instructionMemory.v"

module instructionMemory_tb;


reg [15:0]address;
wire [15:0] instruction;


instructionMemory instructionMemoryU
(
	.address (address),
	.instruction (instruction)
);

initial
begin
	address = 0;
end

always
	#5 address = address + 2;

initial
begin

	$display("\t\ttime\tAddress\tInstruction");
	$monitor("%d\t%h\t%b", $time, address, instruction);

	#5
	#5
	#5
	#5
	#5
	#5
	#5
	#5
	#5
	#5
	#5
	#5
	#5
	#5
	#5
	#5
	#5
	#5
	#5
	#5
	#5
	#5
	#5
	#5
	#5
	#5
	#5
	#5
	#5
	#5
	#5
	#5
	#5
	#5
	#5
	#5
	#5
	#5
	#5
	#5
	#5
	#5
	
	



	#10 $finish;
end

endmodule