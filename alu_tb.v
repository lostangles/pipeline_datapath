
`include "alu.v"

module alu_tb;


reg [15:0] A, B;
reg [1:0] Function;

wire [31:0] Out;
wire O, N, Z;

ALU alu
(
	.A (A),
	.B (B),
	.Function (Function),
	.Out (Out),
	.O (O),
	.N (N),
	.Z (Z)
);

initial
begin
	A = 0;
	B = 0;
	Function = 4'b00;
end


initial
begin

	$display("\t\ttime\tOperA\tOperB\tImmed\tFctn\tALUSrc\tALUOp\tALUOut\t\tof_ex");
	$monitor("%d\t%h\t%h\t%h\t%h\t%b\t%b\t%h\t%b", $time, A, B, Function, Out, O, N, Z);
//Addition
	#5			   A = 16'hFF00;   B = 16'hFFFF; Function = 4'b0000;

//Subtraction	
	#5			   A = 16'hFF00;   B = 16'hFFFF; Function = 4'b0001;

	
//AND
    #5             A = 16'hFFFF;   B = 16'hB0B0; Function = 4'b1000;

//OR
    #5             A = 16'hFFFF;   B = 16'hB0B0; Function = 4'b1001;
	
//Mult
#5             A = 16'hFFFF;   B = 16'hB0B0; Function = 4'b0100;

//Div
#5             A = 16'hFFFF;   B = 16'hB0B0; Function = 4'b0101;

//Memory
#5             A = 16'h0000;   B = 16'h0008; Function = 4'b1100;



	#10 $finish;
end

endmodule