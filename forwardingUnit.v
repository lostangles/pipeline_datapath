//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/29/2016 09:01:21 PM
// Design Name: 
// Module Name: forwardingUnit
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module forwardingUnit(
    input [3:0] Op1AddrFromIFID,
    input [3:0] Op2AddrFromIFID,
    input [3:0] Op1AddrFromIDEX,
    input [3:0] Op2AddrFromIDEX,
    input [3:0] Op1AddrFromEXMEM,
    input [3:0] Op2AddrFromEXMEM,
    input [3:0] Op1AddrFromMEMWB,
    input [3:0] Op2AddrFromMEMWB,
	input [13:0] ControlSignalsFromIDEX,
	input [13:0] ControlSignalsFromEXMEM,
	input [13:0] ControlSignalsFromMEMWB,


    input [15:0] Op1DataFromIDEX,
    input [15:0] Op2DataFromIDEX,
    input [15:0] Op1DataFromEXMEM,
    input [15:0] Op2DataFromEXMEM,
    input [15:0] Op1DataFromMEMWB,
    input [15:0] Op2DataFromMEMWB,
    
    output reg [15:0] ComparatorMUX1In,
    output reg [15:0] ComparatorMUX2In,
    
    output reg [15:0] ALUOp1In,
    output reg [15:0] ALUOp2In,


    output reg  ComparatorMUX1Src,
    output reg  ALUOp1Src,
    output reg  ALUOp2Src,
    output reg  ComparatorMUX2Src
    );
    

	
	
//Stage 2 - Op1Data going to PC comparator MUX	-- Does not take into account something like swap R1, R15, but this is not tested for in the code to execute
always @ (*)
begin
	if ( (Op1AddrFromIFID == Op1AddrFromIDEX) && ~ControlSignalsFromIDEX[11] )
	begin
		ComparatorMUX1Src = 1; 
		ComparatorMUX1In  = Op1DataFromIDEX;
	end
	else if ( (Op1AddrFromIFID == Op1AddrFromEXMEM) && ~ControlSignalsFromEXMEM[11] ) //[11] = WriteEnable1 for registers
	begin
		ComparatorMUX1Src = 1;
		ComparatorMUX1In  = Op1DataFromEXMEM;
	end
	else if ( (Op1AddrFromIFID == Op1AddrFromMEMWB) && ~ControlSignalsFromMEMWB[11] )
	begin
		ComparatorMUX1Src = 1;
		ComparatorMUX1In  = Op1DataFromMEMWB;
	end
	else
	begin
		ComparatorMUX1Src = 0;
	end
end

//Stage 2 - Reg15 going to PC comparator MUX -- Have to look for if something is going into R15 from a mult, div, move, or swap cmd - this isn't tested for in example code but should work
always @ (*)
begin
	if ( ((~ControlSignalsFromIDEX[10] && ~ControlSignalsFromIDEX[9]) || (Op1AddrFromIDEX == 4'b1111 && ~ControlSignalsFromEXMEM[11]) ) )
	begin
	    if ( ~(Op1AddrFromIDEX == 4'b1111 ))
	    begin
	   	  ComparatorMUX2Src = 1; 
		  ComparatorMUX2In  = Op2DataFromIDEX;
		end
		else
		begin
		  ComparatorMUX2Src = 1; 
          ComparatorMUX2In  = Op1DataFromIDEX;
        end
	end
	else if ( ((~ControlSignalsFromEXMEM[10] && ~ControlSignalsFromEXMEM[9]) || (Op1AddrFromEXMEM == 4'b1111 && ~ControlSignalsFromEXMEM[11]) ) )
	begin
	    if ( ~(Op1AddrFromEXMEM == 4'b1111 ))
	    begin
	   	  ComparatorMUX2Src = 1; 
		  ComparatorMUX2In  = Op2DataFromEXMEM;
		end
		else
		begin
		  ComparatorMUX2Src = 1; 
          ComparatorMUX2In  = Op1DataFromEXMEM;
        end
	end
	else if ( ((~ControlSignalsFromMEMWB[10] && ~ControlSignalsFromMEMWB[9]) || (Op1AddrFromMEMWB == 4'b1111 && ~ControlSignalsFromMEMWB[11]) ) )
        begin
            if ( ~(Op1AddrFromMEMWB == 4'b1111 ))
            begin
              ComparatorMUX2Src = 1; 
              ComparatorMUX2In  = Op2DataFromMEMWB;
            end
            else
            begin
              ComparatorMUX2Src = 1; 
              ComparatorMUX2In  = Op1DataFromMEMWB;
            end
        end
	else
		ComparatorMUX2Src = 0;
end



//Stage 3 - Op1Data going into ALU Mux
always @ (*)
begin
	if ( (Op1AddrFromIDEX == Op1AddrFromEXMEM) && ~ControlSignalsFromEXMEM[11] )
	begin
		ALUOp1Src = 1; 
		ALUOp1In  = Op1DataFromEXMEM;
	end
	else if ( (Op1AddrFromIDEX == Op1AddrFromMEMWB) && ~ControlSignalsFromMEMWB[11] ) //[11] = WriteEnable1 for registers
	begin
		ALUOp1Src = 1;
		ALUOp1In  = Op1DataFromMEMWB;
	end
	else
	begin
		ALUOp1Src = 0;
	end
end

//Stage 3 - Op2Data going into ALU Mux
always @ (*)
begin
	if ( (Op2AddrFromIDEX == Op1AddrFromEXMEM) && ~ControlSignalsFromEXMEM[11] )
	begin
		ALUOp2Src = 1; 
		ALUOp2In  = Op1DataFromEXMEM;
	end
	else if ( (Op2AddrFromIDEX == Op1AddrFromMEMWB) && ~ControlSignalsFromMEMWB[11] ) //[11] = WriteEnable1 for registers
	begin
		ALUOp2Src = 1;
		ALUOp2In  = Op1DataFromMEMWB;
	end
	else
	begin
		ALUOp2Src = 0;
	end
end


    
endmodule
