//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/03/2016 01:40:34 PM
// Design Name: 
// Module Name: hazardDetector
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


module hazardDetector(
    input [3:0] Op1,
    input [3:0] Op2,
    input ExceptionFromCU,
    input MemoryOp,
    input [3:0] Op1AddrFromIDEX,
    output reg PCHalt,
    output reg BufferHalt,
    output reg ControlHalt
    );
    
    always @ (*)
    begin
        if ( ((Op1 == Op1AddrFromIDEX || Op2 == Op1AddrFromIDEX) && ~MemoryOp) || ~ExceptionFromCU)
        begin
            PCHalt = 1;
            BufferHalt = 1;
            ControlHalt = 0;
        end
        else
        begin
            PCHalt = 0;
            BufferHalt = 0;
            ControlHalt = 1;
        end
    end
    
    
endmodule
