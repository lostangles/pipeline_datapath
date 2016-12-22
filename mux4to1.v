//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/27/2016 11:23:41 AM
// Design Name: 
// Module Name: mux4to1
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


module mux4to1(
    input [15:0] Op1Data,
    input [31:0] ALUResultFromEX,
    input [15:0] MemRead,
    input [1:0] src,
    output reg [15:0] out
    );
    
    always @ (*)
    begin
    case (src)
        2'b00 : out = Op1Data;
        2'b01 : out = ALUResultFromEX[31:16];
        2'b10 : out = ALUResultFromEX[15:0];
        2'b11 : out = MemRead;
    endcase
    
    end
    
endmodule
