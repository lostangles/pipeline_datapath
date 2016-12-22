module programCounter (input clk,
					   input rst,
					   input [15:0] next_address,
					   output reg [15:0] address);
	
	always @ (posedge clk or negedge rst) 
	begin
		if (~rst)
			address <= 16'h0000;
		else
			address <= next_address;
	end
	
					   

					   
endmodule