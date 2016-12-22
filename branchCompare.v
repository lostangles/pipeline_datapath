//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/26/2016 03:41:03 PM
// Design Name: 
// Module Name: branchCompare
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


module branchCompare(
    input [15:0] A,
    input [15:0] B,
    input [1:0] mode,
    output reg out
    );
    
//Modes:  00 : Equals
//        01 : Greater than
//        10 : Less than    
    
    
    always @ (*)
    begin
        case (mode)
            2'b00 : if (A == B) out = 1; else out = 0;
            2'b01 : if (A > B ) out = 1; else out = 0;
            2'b10 : if (A < B ) out = 1; else out = 0;
            default: out = 0;
        endcase
    end
    
    
    
    
endmodule
