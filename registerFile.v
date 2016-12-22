module registerFile (input clk,
					 input rst,
					 input WE1,
					 input WE2,
					 input [3:0] Op1,
					 input [3:0] Op2,
					 input [3:0] WriteAddress1,
					 input [3:0] WriteAddress2,
					 input [15:0] WriteData1,
					 input [15:0] WriteData2,
					 output reg [15:0] Op1Data,
					 output reg [15:0] Op2Data,
					 output reg [15:0] Reg15Data
					 );
	
	reg [15:0] Register [15:0];


	always @ (*)
	begin
		Op1Data = Register[Op1];
		Op2Data = Register[Op2];
		Reg15Data = Register[15];	
	end
	
	always @ (posedge clk or negedge rst)
	begin
		if (~rst)
		begin
			Register[4'b0000] <= 16'h0000;
			Register[4'b0001] <= 16'h0F00;
			Register[4'b0010] <= 16'h0050;
			Register[4'b0011] <= 16'hFF0F;
			Register[4'b0100] <= 16'hF0FF;
			Register[4'b0101] <= 16'h0040;
			Register[4'b0110] <= 16'h6666;
			Register[4'b0111] <= 16'h00FF;
			Register[4'b1000] <= 16'hFF88;
			Register[4'b1001] <= 16'h0000;
			Register[4'b1010] <= 16'h0000;
			Register[4'b1011] <= 16'h0000;
			Register[4'b1100] <= 16'hCCCC;
			Register[4'b1101] <= 16'h0002;
			Register[4'b1110] <= 16'h0000;
			Register[4'b1111] <= 16'h0000;
		end
		//else if (WE1) 
		//begin
		//	Register[WriteAddress1] <= WriteData1;
		//end
		//else if (WE2)
		//begin
		//	Register[WriteAddress2] <= WriteData2;
		//end
		else
		begin
			case ({WE1, WE2})
				2'b00 : begin Register[WriteAddress1] <= WriteData1; Register[WriteAddress2] <= WriteData2; end
				2'b01 : begin Register[WriteAddress1] <= WriteData1; end
				2'b10 : begin Register[WriteAddress2] <= WriteData2; end
				2'b11 : ;
				default : ;
			endcase
		end
	end	

					 
endmodule