//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/27/2016 10:54:16 AM
// Design Name: 
// Module Name: signExtender
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



module signExtender(
    input [7:0] in,
    output reg [15:0] out,
    input [1:0] instructionType
    );
    
        ////////Instruction Types////////////
    //      00 = R-type
    //      01 = Memory-type
    //      10 = Immediate-type
    //      11 = Branch-type
    
always @ (*)
begin
    case(instructionType)
        2'b00 : out = in;  //doesn't matter, no R-type uses sign extension
        2'b01 : out = { {12{in[3]}}, in[3:0]};   
        2'b10 : out = { {8{in[7]}}, in[7:0]}; 
        2'b11 : out = { {8{in[7]}}, in[7:0]}; 
    endcase
        
end
    
    
endmodule
