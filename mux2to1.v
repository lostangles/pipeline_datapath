module mux2to1        #(parameter N=16)
                     (input [N-1:0] in1,
					  input [N-1:0] in0,
					  input src,
					  output reg [N-1:0] out);
		
	always @ (*)
	begin
		if (src)
			out = in1;
		else
			out = in0;
	end
					  
					  
					  
					  
endmodule