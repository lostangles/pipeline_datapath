`include "alu.v"
`include "buffer.v"
`include "instructionMemory.v"
`include "programCounter.v"
`include "registerFile.v"
`include "adder1.v"
`include "controlUnit.v"
`include "mux2to1.v"
`include "signExtender.v"
//`include "mux4to1.v"
//`include "mux5to1.v"
`include "adder2.v"
`include "memory.v"
`include "branchCompare.v"
`include "forwardingUnit.v"
`include "hazardDetector.v"
module cpu (input clk,
			input rst);
			
			
			
			
//////////STAGE 1 - IF/////////////////////
wire [15:0] PC_To_Instruction_Memory;
wire [15:0] Instruction_To_IFID;
wire [15:0] PC_From_Adder;
wire [15:0] PCMux_To_PC;
wire [15:0] PCSource_To_PCMux;
wire [31:0] IDIF_Out;
wire Comparator_To_PCSrc;
wire [15:0] BranchAdderToPC;
wire Halt;
wire PCHalt;
wire BufferHalt;
wire [15:0] InstructionMemToMux;



defparam IDIF.N=32;

//Helper modules
adder1 PC_Adder (.PC(PC_To_Instruction_Memory), .PCPlusTwo(PC_From_Adder));

//This mux makes PC update to PC, for halts/exception/hazards
mux2to1 PCMux (.in1(PC_To_Instruction_Memory), .in0(PCSource_To_PCMux), .src(PCHalt), .out(PCMux_To_PC));
//This mux is PCSource
mux2to1 PCSource (.in0(PC_From_Adder), .in1(BranchAdderToPC), .src(Comparator_To_PCSrc), .out(PCSource_To_PCMux));

programCounter PC(.clk(clk), .rst(rst), .address(PC_To_Instruction_Memory), .next_address(PCMux_To_PC));

instructionMemory InstMemory(.address(PC_To_Instruction_Memory),
						  .instruction(InstructionMemToMux) );
						  
mux2to1 NOPMux(.in0(InstructionMemToMux), .in1(16'b0000000000000000), .src(Comparator_To_PCSrc), .out(Instruction_To_IFID));
			

buffer IDIF (.clk(clk), .rst(rst), .we(BufferHalt), .in( {Instruction_To_IFID, PC_From_Adder} ), .out(IDIF_Out));
 

/////////END STAGE 1/////////////////////////

//////////STAGE 2 - ID///////////////////////
wire [15:0] Op1Data_To_IDEX;
wire [15:0] Op2Data_To_IDEX;
wire [15:0] Immediate_To_IDEX;
wire [13:0] Control_To_IDEX;
wire [69:0] IDEX_Out;
wire [3:0]  Op1AddressFromIDEX;
wire [3:0]  Op2AddressFromIDEX;
wire [3:0]  Op1AddressFromEXMEM;
wire [3:0]  Op2AddressFromEXMEM;
wire [15:0] Reg15;
wire [85:0] EXMEM_Out;

wire [3:0]  Op1AddressFromIFID;
wire [3:0]  Op2AddressFromIFID;

assign Op1AddressFromIFID = IDIF_Out[27:24];
assign Op2AddressFromIFID = IDIF_Out[23:20];

wire [15:0] Comparator1MUX;
wire [15:0] Comparator2MUX;


wire [13:0] Control_Signals;
wire [1:0] BranchMode_wire;
wire [31:0] ALUResult;

wire [15:0] MemoryData;
wire [69:0] MEMWB_Out;
wire [15:0] WBMux_Out;

wire [15:0] ALUResultHighFromWB;
wire [15:0] ALUResultLowFromWB;
assign ALUResultHighFromWB = MEMWB_Out[45:30];
assign ALUResultLowFromWB = WBMux_Out;

wire [3:0] Op1AddressFromMEMWB;
assign Op1AddressFromMEMWB = MEMWB_Out[49:46];

wire [3:0] Op2AddressFromMEMWB;
assign Op2AddressFromMEMWB = MEMWB_Out[69:66];

wire [13:0] ControlSignalsFromMEMWB;
assign ControlSignalsFromMEMWB = MEMWB_Out[13:0];

wire [3:0] WriteAdd2Mux;
wire [13:0] ControlSignalsFromIDEX;
wire [13:0] ControlSignalsFromEXMEM;
wire [13:0] ControlSignalsFromEXWB;


wire  Cmp1MUXSrc;
wire  ALU1MUXSrc;
wire  ALU2MUXSrc;
wire  Cmp2MUXSrc;
wire [15:0] ComparatorMUX1In;
wire [15:0] ComparatorMUX2In;
wire [15:0] ALUMUX1In;
wire [15:0] ALUMUX2In;
wire ControlMuxSRC;

//Buffer size = 16 bits for Op1Data [0:15]
//              16 bits for Op2Data [16:31]
//              16 bits for Immediate [32:47]
//              4  bits for Op1 Address [48:50]
//              4  bits for Op2 address [51:54]
//              14 bits for Control Sigs [55:68]
defparam IDEX.N = 70;
defparam ControlMUX.N = 14;
defparam WriteAddress2MUX.N = 4;


hazardDetector hazardDetector(    .Op1(Op1AddressFromIFID),
    .Op2(Op2AddressFromIFID),
    .ExceptionFromCU(Halt),
    .MemoryOp(ControlSignalsFromIDEX[8]),
    .Op1AddrFromIDEX(Op1AddressFromIDEX),
    .PCHalt(PCHalt),
    .BufferHalt(BufferHalt),
    .ControlHalt(ControlMuxSRC)
    );

controlUnit ControlUnit(     
    .Op (IDIF_Out[31:28]),
    .Function (IDIF_Out[19:16]),
    .ALUOp (Control_Signals[13:13]),
    .ALUSrc (Control_Signals[12:12]),
    .RegWrite1EN (Control_Signals[11:11]),
    .RegWrite2EN (Control_Signals[10:10]),
    .Write2AddMux (Control_Signals[9:9]),
    .MemToReg (Control_Signals[8:8]),
    .MemWriteEN (Control_Signals[7:7]),
    .InstructionType (Control_Signals[6:5]),
    .ByteOp (Control_Signals[4:4]),
    .ALUFunction (Control_Signals[3:0]),
    .BranchMode (BranchMode_wire),
    .Halt (Halt)
    );
    
mux2to1 ControlMUX(.in1(Control_Signals), .in0(14'b11111111111111), .src(ControlMuxSRC), .out(Control_To_IDEX));   

forwardingUnit ForwardingUnit(   
    .Op1AddrFromIFID(Op1AddressFromIFID),
    .Op2AddrFromIFID(Op2AddressFromIFID),
    .Op1AddrFromIDEX(Op1AddressFromIDEX),
    .Op2AddrFromIDEX(Op2AddressFromIDEX),
    .Op1AddrFromEXMEM(Op1AddressFromEXMEM),
    .Op2AddrFromEXMEM(Op2AddressFromEXMEM),
    .Op1AddrFromMEMWB(Op1AddressFromMEMWB),
    .Op2AddrFromMEMWB(Op2AddressFromMEMWB),
    .ComparatorMUX1Src(Cmp1MUXSrc),
    .ComparatorMUX2Src(Cmp2MUXSrc),

    .ALUOp1Src(ALU1MUXSrc),
    .ALUOp2Src(ALU2MUXSrc),
    .ALUOp1In(ALUMUX1In),
    .ALUOp2In(ALUMUX2In),
    .ComparatorMUX1In(ComparatorMUX1In),
    .ComparatorMUX2In(ComparatorMUX2In),
    .Op1DataFromIDEX(ALUResult[15:0]),
    .Op2DataFromIDEX(ALUResult[31:16]),
    .Op1DataFromEXMEM(EXMEM_Out[29:14]),
    .Op2DataFromEXMEM(EXMEM_Out[45:30]),
    .Op1DataFromMEMWB(ALUResultLowFromWB),
    .Op2DataFromMEMWB(ALUResultHighFromWB),
    .ControlSignalsFromIDEX(ControlSignalsFromIDEX),
    .ControlSignalsFromEXMEM(ControlSignalsFromEXMEM),
    .ControlSignalsFromMEMWB(ControlSignalsFromMEMWB) );

mux2to1 WriteAddress2MUX(.in1(Op2AddressFromMEMWB), .in0(4'b1111), .src(ControlSignalsFromMEMWB[9:9]), .out(WriteAdd2Mux));

mux2to1 Op1DataMUX(.in0(Op1Data_To_IDEX), .in1(ComparatorMUX1In), .src(Cmp1MUXSrc), .out(Comparator1MUX));
mux2to1 Op2DataMUX(.in0(Op2Data_To_IDEX), .in1(ComparatorMUX2In), .src(Cmp2MUXSrc), .out(Comparator2MUX));

    
registerFile Registers(.clk(clk), .rst(rst), .WE1(ControlSignalsFromMEMWB[11]), .WE2(ControlSignalsFromMEMWB[10]), .Op1(IDIF_Out[27:24]), .Op2(IDIF_Out[23:20]),      .WriteAddress1(Op1AddressFromMEMWB), .WriteAddress2(WriteAdd2Mux), .WriteData1(ALUResultLowFromWB), .WriteData2(ALUResultHighFromWB), .Op1Data(Op1Data_To_IDEX), .Op2Data(Op2Data_To_IDEX), .Reg15Data(Reg15)) ;

branchCompare BranchComperator( .A(Comparator1MUX), .B(Comparator2MUX), .mode(BranchMode_wire), .out(Comparator_To_PCSrc)        );

signExtender SignExtend ( .in(IDIF_Out[23:16]), .out(Immediate_To_IDEX), .instructionType(Control_Signals[6:5]));

adder2 PC_Plus_Sign_Extension(.PC(IDIF_Out[15:0]), .SignExtended(Immediate_To_IDEX), .out(BranchAdderToPC) );

///WARNING: All buffer signals are mixed together as a single 69 bit signal.  Take care to retrieve the correct data by taking the correct bit groups
buffer IDEX (.clk(clk), .rst(rst), .we(1'b0), .in({Op1Data_To_IDEX, 
                                                 Op2Data_To_IDEX,
                                                 Immediate_To_IDEX,
                                                 IDIF_Out[27:24],
                                                 IDIF_Out[23:20],
                                                 Control_To_IDEX
                                                }), 
                                                .out(IDEX_Out));

/////////END STAGE 2/////////////////////////



//////////STAGE 3 - EX///////////////////////

wire [15:0] Op1DataFromIDEX;
wire [15:0] Op2DataFromIDEX;
wire [15:0] ImmediateFromIDEX;


assign Op1DataFromIDEX = IDEX_Out[69:54];
assign Op2DataFromIDEX = IDEX_Out[53:38];
assign ImmediateFromIDEX = IDEX_Out[37:22];
assign Op1AddressFromIDEX = IDEX_Out[21:18];
assign Op2AddressFromIDEX = IDEX_Out[17:14];
assign ControlSignalsFromIDEX = IDEX_Out[13:0];

wire [15:0] Op1MUXOut;
wire [15:0] Op2MUXOut;
wire [15:0] Op1ALUInput;
wire [15:0] Op2ALUInput;





    
mux2to1 Op1SRC(.in0(Op1DataFromIDEX), .in1(ALUMUX1In), .src(ALU1MUXSrc), .out(Op1MUXOut));
    
mux2to1 Op2SRC(.in0(Op2DataFromIDEX), .in1(ALUMUX2In), .src(ALU2MUXSrc), .out(Op2MUXOut));
        
    


mux2to1 ALU1Src (.in1(ImmediateFromIDEX),
         .in0(Op1MUXOut),
         .src( ~ControlSignalsFromIDEX[6:6] & ControlSignalsFromIDEX[5:5] ),
         .out(Op1ALUInput));
         
mux2to1 ALU2Src (.in1(ImmediateFromIDEX),
                  .in0(Op2MUXOut),
                  .src(ControlSignalsFromIDEX[12:12]),
                  .out(Op2ALUInput));         
         
alu ALU    (.A(Op1ALUInput),
         .B(Op2ALUInput),
         .Function(ControlSignalsFromIDEX[3:0]),
         .Out(ALUResult),
         .O(),
         .Z(),
         .N());

////////////Buffer EXMEM bit numbers
//          ControlSignalsFromIDEX [13:0]
//          ALUResult              [45:14]
//          Op1ALUInput            [61:46]
//          Op1AddressFromIDEX     [65:62]
//          Op2AddressFromIDEX     [69:66]
//          Op1DataFromIDEX        [85:70]

defparam EXMEM.N = 86;

buffer EXMEM (.clk(clk), .rst(rst), .we(1'b0), .in({Op1DataFromIDEX,
                                                 Op2AddressFromIDEX,
                                                 Op1AddressFromIDEX,
                                                 Op1ALUInput,
                                                 ALUResult,
                                                 ControlSignalsFromIDEX
                                                }), 
                                                .out(EXMEM_Out));
/////////END STAGE 3/////////////////////////



//////////STAGE 4 - MEM//////////////////////

wire [31:0] ALUResultFromEXMEM;


assign Op1AddressFromEXMEM = EXMEM_Out[65:62];
assign Op2AddressFromEXMEM = EXMEM_Out[69:66];
assign ALUResultFromEXMEM = EXMEM_Out[45:14];
assign ControlSignalsFromEXMEM = EXMEM_Out[13:0];



memory Memory(
    .clk(clk),
    .rst(rst),
    .Address(EXMEM_Out[29:14]),
    .DataOut(MemoryData),
    .DataIn(EXMEM_Out[85:70]),
    .MemWrite(ControlSignalsFromEXMEM[7:7]),
    .ByteOp(ControlSignalsFromEXMEM[4])
    );
////////////Buffer MEMWB bit numbers
//          ControlSignalsFromEXMEM  [13:0]
//          ALUResultFromEXMEM       [45:14]
//          Op1AddressFromEXMEM      [49:46]
//          MemoryData               [65:50]
//          Op2AddressFromEXMEM      [69:66]
    
    
defparam MEMWB.N = 70;
    
buffer MEMWB (.clk(clk), .rst(rst), .we(1'b0), .in({Op2AddressFromEXMEM,
                                                 MemoryData,
                                                 Op1AddressFromEXMEM,
                                                 ALUResultFromEXMEM,
                                                 ControlSignalsFromEXMEM
                                                }), 
                                                .out(MEMWB_Out));


/////////END STAGE 4/////////////////////////




//////////STAGE 5 - WB///////////////////////
wire [15:0] ALUResultLow;
wire [15:0] MemoryDataFromEXWB;


assign ControlSignalsFromEXWB = MEMWB_Out[13:0];
assign ALUResultLow = MEMWB_Out[29:14];
assign MemoryDataFromEXWB = MEMWB_Out[65:50];


defparam MemToRegMux.N = 16;
mux2to1 MemToRegMux (.in0(MemoryDataFromEXWB), .in1(ALUResultLow), .src(ControlSignalsFromEXWB[8]), .out(WBMux_Out));

/////////END STAGE 5/////////////////////////



 
 
 
endmodule




 
 
 
