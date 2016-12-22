module adder1 (input [15:0] PC,
			  output reg [15:0] PCPlusTwo);
			  
always @ (*)
	begin
		PCPlusTwo = PC + 16'h0002;
	end
	
endmodule