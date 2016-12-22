//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/27/2016 11:47:25 AM
// Design Name: 
// Module Name: adder2
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


module adder2(
    input [15:0] PC,
    input [15:0] SignExtended,
    output reg [15:0] out
    );
  
    always @ (*)
    begin
        out = PC + $signed(SignExtended);
    end

    
endmodule
