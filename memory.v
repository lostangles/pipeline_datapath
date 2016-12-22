//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/27/2016 04:35:57 PM
// Design Name: 
// Module Name: memory
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


module memory(
    input clk,
    input rst,
    input [15:0] Address,
    output reg [15:0] DataOut,
    input [15:0] DataIn,
    input MemWrite,
    input ByteOp
    );
    
    reg [15:0] Memory [31:0];
    integer i;
    
    always @ (posedge clk or negedge rst)
    begin
        if (~rst)
        begin
            for (i=0;i<32;i=i+1)
            begin
                if (i == 0) Memory[i] <= 16'h2BCD;
                else if (i == 2) Memory[i] <= 16'h0000;
                else if (i == 4) Memory[i] <= 16'h1234;
                else if (i == 6) Memory[i] <= 16'hDEAD;
                else if (i == 8) Memory[i] <= 16'hBEEF;
                else
                Memory[i] <= 16'h0000;
            end
        end
        else if (~MemWrite)
        begin
        if (~ByteOp)
            Memory[Address][7:0] <= DataIn[7:0];
            else
            Memory[Address] <= DataIn;
        end
    end
    
    always @ (*)
    begin
        if (~ByteOp)
            DataOut = {8'b00000000, Memory[Address][7:0]};
        else
            DataOut = Memory[Address];
    end
   
endmodule
