//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/26/2016 12:39:34 PM
// Design Name: 
// Module Name: controlUnit
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


module controlUnit(
    input [3:0] Op,
    input [3:0] Function,
    output reg ALUOp,
    output reg ALUSrc,
    output reg RegWrite1EN,
    output reg RegWrite2EN,
    output reg Write2AddMux,
    output reg MemToReg,
    output reg MemWriteEN,
    output reg [1:0] InstructionType,
    output reg Halt,
    output reg [3:0] ALUFunction,
    output reg [1:0] BranchMode,
    output reg ByteOp
    );
    
    
    ////////Instruction Types////////////
    //      00 = R-type
    //      01 = Memory-type
    //      10 = Immediate-type
    //      11 = Branch-type
    
always @ (*)
begin
    case (Op)    
        4'b1111 : begin  //R-type
                  RegWrite1EN = 0;
                  if (Function == 4'b1000 || Function == 4'b0100 || Function == 4'b0101)
                   begin 
                    RegWrite2EN = 0; 
                    if (Function == 4'b1000) 
                    begin 
                        Write2AddMux = 1; 
                    end
                    else 
                    begin 
                        Write2AddMux = 0;
                    end
                   end 
                   else 
                    begin RegWrite2EN = 1; 
                   end
                  MemToReg = 1;
                  ALUOp = 0;
                  ALUSrc = 0;
                  InstructionType = 2'b00;
                  MemWriteEN = 1;
                  if (Function == 4'b1000) ALUFunction = 4'b1101;
                  if (Function == 4'b0111) ALUFunction = 4'b1110;
                  if ( (Function != 4'b1000) && (Function != 4'b0111)) ALUFunction = Function;
                  BranchMode = 2'b11;
                  Halt = 1;
                  ByteOp = 1;

                  end
        4'b1000 : begin   //AND Immediate
                    RegWrite1EN = 0;
                    RegWrite2EN = 1;
                    MemToReg = 1;
                    ALUOp = 0;
                    ALUSrc = 1; //using immediate
                    InstructionType = 2'b10;
                    MemWriteEN = 1;
                    ALUFunction = 4'b1000;
                    BranchMode = 2'b11;
                    Halt = 1;
                    ByteOp = 1;

                    end
        4'b1001 : begin  //OR Immediate
                    RegWrite1EN = 0;
                    RegWrite2EN = 1;
                    MemToReg = 1;
                    ALUOp = 0;
                    ALUSrc = 1; //using immediate
                    InstructionType = 2'b10;
                    MemWriteEN = 1;
                    ALUFunction = 4'b1001;
                    BranchMode = 2'b11;
                    Halt = 1;
                    ByteOp = 1;
                    end
        4'b1010 : begin  //Load byte
                    RegWrite1EN = 0;
                    RegWrite2EN = 1;
                    MemToReg = 0; //Taking data from memory
                    ALUOp = 0;
                    ALUSrc = 0; //using immediate
                    InstructionType = 2'b01;
                    MemWriteEN = 1;
                    ALUFunction = 4'b1111;
                    ByteOp = 0;
                    BranchMode = 2'b11;
                    Halt = 1;
                    end 
         4'b1100 : begin  //Load word
                    RegWrite1EN = 0;
                    RegWrite2EN = 1;
                    MemToReg = 0; //Taking data from memory
                    ALUOp = 0;
                    ALUSrc = 0; //using immediate
                    InstructionType = 2'b01;
                    MemWriteEN = 1;
                    ALUFunction = 4'b1100;
                    ByteOp = 1;
                    BranchMode = 2'b11;
                    Halt = 1;

                    end                                       
        4'b1011 : begin  //Store byte
                    RegWrite1EN = 1;
                    RegWrite2EN = 1;
                    MemToReg = 0; //Taking data from memory
                    ALUOp = 0;
                    ALUSrc = 0; //using immediate
                    InstructionType = 2'b01;
                    MemWriteEN = 0;
                    ALUFunction = 4'b1111;
                    ByteOp = 0;
                    BranchMode = 2'b11;
                    Halt = 1;

                    end 
         4'b1101 : begin  //Store word
                    RegWrite1EN = 1;
                    RegWrite2EN = 1;
                    MemToReg = 0; //Taking data from memory
                    ALUOp = 0;
                    ALUSrc = 0; //using immediate
                    InstructionType = 2'b01;
                    MemWriteEN = 0;
                    ALUFunction = 4'b1100;
                    ByteOp = 1;     
                    BranchMode = 2'b11;
                    Halt = 1;               
                    end                                       
         4'b0101 : begin  //Branch on less than
                   RegWrite1EN = 1;
                   RegWrite2EN = 1;
                   MemToReg = 1; //Taking data from memory
                   ALUOp = 1;
                   ALUSrc = 1; //using immediate
                   InstructionType = 2'b11;
                   MemWriteEN = 1;
                   ALUFunction = 0;
                   BranchMode = 2'b10;
                   Halt = 1;
                   ByteOp = 1;
                   end                                       
         4'b0100 : begin  //Branch on greater than
                  RegWrite1EN = 1;
                  RegWrite2EN = 1;
                  MemToReg = 1; //Taking data from memory
                  ALUOp = 1;
                  ALUSrc = 1; //using immediate
                  InstructionType = 2'b11;
                  MemWriteEN = 1;
                  ALUFunction = 0;
                  BranchMode = 2'b01;
                  Halt = 1;
                  ByteOp = 1;
                  end                                       
         4'b0110 : begin  //Branch on equal
                 RegWrite1EN = 1;
                 RegWrite2EN = 1;
                 MemToReg = 1; //Taking data from memory
                 ALUOp = 1;
                 ALUSrc = 1; //using immediate
                 InstructionType = 2'b11;
                 MemWriteEN = 1;
                 ALUFunction = 0;
                 BranchMode = 2'b00;
                 Halt = 1;
                 ByteOp = 1;
                 end                                       
         4'b0000 : begin  //Jump - not really implemented, used as NOP
                RegWrite1EN = 1;
                RegWrite2EN = 1;
                MemToReg = 1; //Taking data from memory
                ALUOp = 1;
                ALUSrc = 1; //using immediate
                InstructionType = 2'b11;
                MemWriteEN = 1;
                ALUFunction = 0;
                Halt = 1;
                ByteOp = 1;
                end                                       
                                                                                                                   
        default : begin
                  RegWrite1EN = 1;
                  RegWrite2EN = 1;
                  MemToReg = 1;
                  ALUOp = 1;
                  ALUSrc = 1;
                  InstructionType = 2'b11;
                  MemWriteEN = 1;      
                  ALUFunction = 1;
                  Halt = 0;
                  ByteOp = 1;
                  end    
        endcase
end
    
    
endmodule
