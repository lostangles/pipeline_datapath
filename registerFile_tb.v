`timescale 1ns/1ps
`include "registerFile.v"

module registerFile_tb;


reg clk;
reg rst;
reg WE1;
reg WE2;
reg [3:0] Op1;
reg [3:0] Op2;
reg [3:0] WriteAddress1;
reg [3:0] WriteAddress2;
reg [15:0] WriteData1;
reg [15:0] WriteData2;
wire [15:0] Op1Data;
wire [15:0] Op2Data;
wire [15:0] Reg15Data;



registerFile registerFileU
(
	.clk (clk),
	.rst (rst),
	.WE1 (WE1),
	.WE2 (WE2),
	.Op1 (Op1),
	.Op2 (Op2),
	.WriteAddress1 (WriteAddress1),
	.WriteAddress2 (WriteAddress2),
	.WriteData1 (WriteData1),
	.WriteData2 (WriteData2),
	.Op1Data (Op1Data),
	.Op2Data (Op2Data),
	.Reg15Data (Reg15Data)
);

initial
begin
	clk = 1;
	rst = 0;
	WE1 = 1;
	WE2 = 1;
	Op1 = 0;
	Op2 = 0;
	WriteAddress1 = 0;
	WriteAddress2 = 0;
	WriteData1 = 0;
	WriteData2 = 0;
end

always
	#5 clk = !clk;

initial
begin

	$display("\t\ttime\tOp1\tOp2\tOp1Data\tOp2Data\tWE1\tWE2\tWriteAddress1\tWriteAddress2\tWriteData1\tWriteData2");
	$monitor("%d\t%d\t%d\t%h\t%h\t%b\t%b\t%d\t\t%d\t\t%h\t\t%h", $time, Op1, Op2, Op1Data, Op2Data, WE1, WE2, WriteAddress1, WriteAddress2, WriteData1, WriteData2);

	#10 rst = 1;
	
	//Check each Register
	#10 Op1 = 4'b0000; Op2 = 4'b0001;
	#10 Op1 = 4'b0010; Op2 = 4'b0011;
	#10 Op1 = 4'b0100; Op2 = 4'b0101;
	#10 Op1 = 4'b0110; Op2 = 4'b0111;
	#10 Op1 = 4'b1000; Op2 = 4'b1001;
	#10 Op1 = 4'b1010; Op2 = 4'b1011;
	#10 Op1 = 4'b1100; Op2 = 4'b1101;
	#10 Op1 = 4'b1110; Op2 = 4'b1111;
	
	//Perform a Write into WriteAddress1 and check it
	#10 WriteAddress1 = 4'b0000; WriteData1 = 16'hDEAD; WE1 = 0; 
	
	#10 WE1 = 1; Op1 = 4'b0000; Op2 = 4'b0000;
	#10
	//Perform a Write into WriteAddress2 and check it
	#10 WriteAddress2 = 4'b0001; WriteData2 = 16'hBEEF; WE2 = 0; 
	#10 WE2 = 1; Op1 = 4'b0001; Op2 = 4'b0000;
	#10
	//Perform a Write into WriteAddress1 & 2 and check it
	#10 WriteAddress1 = 4'b0010; WriteData1 = 16'hDEAD; WE1 = 0; WriteAddress2 = 4'b0011; WriteData2 = 16'hBEEF; WE2 = 0; 
	#10 WE1 = 1; Op1 = 4'b0010; WE2 = 1; Op2 = 4'b0011;
	#10
	
	//Confirm reset works
	#10 rst = 0;
	//Check each Register
	#10 Op1 = 4'b0000; Op2 = 4'b0001;
	#10 Op1 = 4'b0010; Op2 = 4'b0011;
	#10 Op1 = 4'b0100; Op2 = 4'b0101;
	#10 Op1 = 4'b0110; Op2 = 4'b0111;
	#10 Op1 = 4'b1000; Op2 = 4'b1001;
	#10 Op1 = 4'b1010; Op2 = 4'b1011;
	#10 Op1 = 4'b1100; Op2 = 4'b1101;
	#10 Op1 = 4'b1110; Op2 = 4'b1111;
	
	



	#10 $finish;
end

endmodule