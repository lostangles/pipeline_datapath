module instructionMemory (input [15:0] address,
						  output reg [15:0] instruction );
			
	always @ (*)
	begin
		case(address)
		16'h0000: instruction = 16'b1111000100100000;
		16'h0002: instruction = 16'b1111000100100001;
		16'h0004: instruction = 16'b1001001111111111;
		16'h0006: instruction = 16'b1000001101001100;
		16'h0008: instruction = 16'b1111010101100100;
		16'h000a: instruction = 16'b1111000101010101;
		16'h000c: instruction = 16'b1111111111110001;
		16'h000e: instruction = 16'b1111010010000111;
		16'h0010: instruction = 16'b1111010001101000;
		16'h0012: instruction = 16'b1001010000000010;
		16'h0014: instruction = 16'b1010011010010100;
		16'h0016: instruction = 16'b1011011010010110;
		16'h0018: instruction = 16'b1100011010010110;
		16'h001a: instruction = 16'b0110011100000100;
		16'h001c: instruction = 16'b1111101100010000;
		16'h001e: instruction = 16'b0101011100000101;
		16'h0020: instruction = 16'b1111101100100000;
		16'h0022: instruction = 16'b0100011100000010;
		16'h0024: instruction = 16'b1111000100010000;
		16'h0026: instruction = 16'b1111000100010000;
		16'h0028: instruction = 16'b1100100010010000;
		16'h002a: instruction = 16'b1111100010000000;
		16'h002c: instruction = 16'b1101100010010010;
		16'h0030: instruction = 16'b1100101010010010;
		16'h0032: instruction = 16'b1111110111010001;
		16'h0034: instruction = 16'b1111110011010000;
		16'h0036: instruction = 16'hEFFF;
		default: instruction = 16'h0000;
		endcase
	end
endmodule