`timescale 1ns/1ps
`include "programCounter.v"

module programCounter_tb;


reg [15:0]next_address;
reg clk;
reg rst;
wire [15:0] address;



programCounter programCounterU
(
	.clk (clk),
	.rst (rst),
	.next_address (next_address),
	.address (address)
);

initial
begin
	next_address = 0;
	clk = 1;
	rst = 1;
end

always
	#5 clk = ~clk;

always
	#10 next_address = address + 2;
initial
begin

	$display("\t\ttime\tAddress\tNext_Address\tReset");
	$monitor("%d\t%h\t%h\t\t%b", $time, address, next_address,rst);

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