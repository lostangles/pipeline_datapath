//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/27/2016 11:40:09 AM
// Design Name: 
// Module Name: mux5to1
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


module mux5to1(
    input [15:0] OpData,
    input [31:0] ALUResultFromMem,
    input [31:0] ALUResultFromWB,
    input [2:0] src,
    output reg [15:0] out
    );
    
    
   always @ (*)
    begin
    case (src)
        3'b000 : out = OpData;
        3'b001 : out = ALUResultFromMem[31:16];
        3'b010 : out = ALUResultFromMem[15:0];
        3'b011 : out = ALUResultFromWB[31:16];
        3'b100 : out = ALUResultFromWB[15:0];        
    endcase
    
    end 
    
    
endmodule
