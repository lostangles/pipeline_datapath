module buffer #(parameter N=16)
			   (input [N-1:0] in,
			    input clk,
				input rst,
				input we,
				output reg [N-1:0] out);
				
				
	always @ (posedge clk or negedge rst)
	begin
		if (~rst)
			out <= {13{1'b1}}; //reset sets all control signals to 1, so no unwanted writes.
		else
		begin 
			if (~we)
			out <= in;
			else
			out <= out;
		end
	
	end
endmodule