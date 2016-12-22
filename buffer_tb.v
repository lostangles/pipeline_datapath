`timescale 1ns/1ps
`include "buffer.v"

module buffer_tb;


reg [15:0]in;
reg clk;
reg rst;
reg we;
wire [15:0] out;



buffer bufferU
(
	.clk (clk),
	.rst (rst),
	.in (in),
	.we (we),
	.out (out)
);

initial
begin
	in = 0;
	clk = 1;
	rst = 1;
	we = 1;
end

always
	#5 clk = ~clk;


initial
begin

	$display("\t\ttime\tIn\tOut\tReset\tWE");
	$monitor("%d\t%h\t%h\t%b\t%b", $time, in, out,rst,we);

	#10 rst = 0;
	#10 rst = 1;
	#10 
	#10 
	#10 in = 16'hDEAD; we = 0;
	#10 in = 16'hBEEF; we = 1;
	#10 we = 0;
	#10 we = 1;
	#10 
	#10	
	#10 
	#10 
	#10 
	#10 
	#10 
	#10 rst = 0;
	#10 rst = 1;
	#10
	#10
	#10
	#10
	#10
	#10
	#10
	#10
	#10
	#10
	#10
	#10
	#10
	#10
	#10
	#10
	#10
	#10
	#10
	#10
	#10
	#10 rst = 0;
	#10
	#10
	#10
	
	



	#10 $finish;
end

endmodule