`include "cpu.v"

module cpu_fixture;

reg clk, rst;

cpu CPU (.clk(clk), .rst(rst));

initial
begin
	clk = 1;
	rst = 0;
end

always
	#5 clk =~clk;

initial
begin
	#3
	$display("\nRegister and Memory Contents Before:");
        $display("\n\tRegisters\tMemory");
        $display("\t----------\t-------");
        $display("\tR0:%h\t\tMem[0]:%h", CPU.Registers.Register[0][15:0],CPU.Memory.Memory[0][15:0]);
        $display("\tR1:%h\t\tMem[1]:%h", CPU.Registers.Register[1][15:0],CPU.Memory.Memory[1][15:0]);
        $display("\tR2:%h\t\tMem[2]:%h", CPU.Registers.Register[2][15:0],CPU.Memory.Memory[2][15:0]);
        $display("\tR3:%h\t\tMem[3]:%h", CPU.Registers.Register[3][15:0],CPU.Memory.Memory[3][15:0]);
        $display("\tR4:%h\t\tMem[4]:%h", CPU.Registers.Register[4][15:0],CPU.Memory.Memory[4][15:0]);
        $display("\tR5:%h\t\tMem[5]:%h", CPU.Registers.Register[5][15:0],CPU.Memory.Memory[5][15:0]);
        $display("\tR6:%h\t\tMem[6]:%h", CPU.Registers.Register[6][15:0],CPU.Memory.Memory[6][15:0]);
        $display("\tR7:%h\t\tMem[7]:%h", CPU.Registers.Register[7][15:0],CPU.Memory.Memory[7][15:0]);
        $display("\tR8:%h\t\tMem[8]:%h", CPU.Registers.Register[8][15:0],CPU.Memory.Memory[8][15:0]);
        $display("\tR9:%h", CPU.Registers.Register[9][15:0]);
        $display("\tR10:%h", CPU.Registers.Register[10][15:0]);
        $display("\tR11:%h", CPU.Registers.Register[11][15:0]);
        $display("\tR12:%h", CPU.Registers.Register[12][15:0]);
        $display("\tR13:%h", CPU.Registers.Register[13][15:0]);
        $display("\tR14:%h", CPU.Registers.Register[14][15:0]);
        $display("\tR15:%h\n", CPU.Registers.Register[15][15:0]);


	$display("\t\tclk\tIF\t\t\t\tID\t\t\t\t\t\t\tEX\t\t\t\t\t\tMEM\t\t\t\t\t\tWB");
	#10 rst = 1;
end
always @ (posedge clk)
begin
	$monitor("%d\tPC:%h Instr: %h \t\tOp1:%d Op2:%d OpCode:%b Op1Data:%h Op2Data:%h\tALUOp1:%h ALUOp2:%h ALUOut:%h\t\tMemAddr:%h MemRW:%b DataIn:%h DataOut:%h\tWE1:%b WE2:%b WriteAdd1:%d WriteAdd2:%d WriteData1:%h WriteData2:%h", $time,CPU.PCMux_To_PC,CPU.Instruction_To_IFID, CPU.Registers.Op1, CPU.Registers.Op2, CPU.ControlUnit.Op,CPU.Registers.Op1Data, CPU.Registers.Op2Data, CPU.ALU.A, CPU.ALU.B, CPU.ALU.Out,CPU.Memory.Address, CPU.Memory.MemWrite, CPU.Memory.DataIn, CPU.Memory.DataOut,CPU.Registers.WE1,CPU.Registers.WE2,CPU.Registers.WriteAddress1,CPU.Registers.WriteAddress2,CPU.Registers.WriteData1,CPU.Registers.WriteData2);	

end

initial
begin
	#320
	$display("\nRegister and Memory Contents After:"); 
	$display("\n\tRegisters\tMemory");
	$display("\t----------\t-------");
	$display("\tR0:%h\t\tMem[0]:%h", CPU.Registers.Register[0][15:0],CPU.Memory.Memory[0][15:0]);
	$display("\tR1:%h\t\tMem[1]:%h", CPU.Registers.Register[1][15:0],CPU.Memory.Memory[1][15:0]);
	$display("\tR2:%h\t\tMem[2]:%h", CPU.Registers.Register[2][15:0],CPU.Memory.Memory[2][15:0]);
	$display("\tR3:%h\t\tMem[3]:%h", CPU.Registers.Register[3][15:0],CPU.Memory.Memory[3][15:0]);
	$display("\tR4:%h\t\tMem[4]:%h", CPU.Registers.Register[4][15:0],CPU.Memory.Memory[4][15:0]);
	$display("\tR5:%h\t\tMem[5]:%h", CPU.Registers.Register[5][15:0],CPU.Memory.Memory[5][15:0]);
	$display("\tR6:%h\t\tMem[6]:%h", CPU.Registers.Register[6][15:0],CPU.Memory.Memory[6][15:0]);
	$display("\tR7:%h\t\tMem[7]:%h", CPU.Registers.Register[7][15:0],CPU.Memory.Memory[7][15:0]);
	$display("\tR8:%h\t\tMem[8]:%h", CPU.Registers.Register[8][15:0],CPU.Memory.Memory[8][15:0]);
	$display("\tR9:%h", CPU.Registers.Register[9][15:0]);
	$display("\tR10:%h", CPU.Registers.Register[10][15:0]);
	$display("\tR11:%h", CPU.Registers.Register[11][15:0]);
	$display("\tR12:%h", CPU.Registers.Register[12][15:0]);
	$display("\tR13:%h", CPU.Registers.Register[13][15:0]);
	$display("\tR14:%h", CPU.Registers.Register[14][15:0]);
	$display("\tR15:%h", CPU.Registers.Register[15][15:0]);
	
	
	$finish;
end
endmodule
