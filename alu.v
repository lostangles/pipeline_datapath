module alu(
    input [15:0] A,
    input [15:0] B,
    input [3:0] Function,
    output reg [31:0] Out,
    output O,
    output Z,
    output reg N
    );

    
    
    reg Of_temp2;
    //Of_temp and Of_temp2 allow overflow check to only happen if arithmetic operation
    
    assign Of_temp = (A[15] ^~ B[15]) && (A[15] ^ Out[15]);
    assign O = Of_temp && Of_temp2;
    assign Z = ((A - B) == 0) ? 1 : 0;
    always @(*)
    begin
	
	
	/////FUNCTION CODES/////:
	//0000 Signed Add
	//0001 Signed Subtract
	//0100 Signed Multiplication
	//0101 Signed division
	//1000 AND Immediate
	//1001 OR Immediate
	//1100 Memory operation
	//1101 SWAP
	//1110 MOVE

      
        casex (Function)
            4'b0000 : //add 
                begin
                    Out = $signed(A) + $signed(B);
                    Of_temp2 = 1'b1;
                end
            4'b0001 : //subtract
                begin
                    Out = $signed(A) - $signed(B);
                    Of_temp2 = 1'b1;

                end
            4'b1000 : //AND
                begin
                    Out = A & B;
                    Of_temp2 = 1'b0;
                end
            4'b1001 : //OR
                begin
                    Out = A | B;
                    Of_temp2 = 1'b0;
                end
			4'b1100 : //memory operation 
				begin
					Out = A + B;
					Of_temp2 = 1'b0;
				end
			4'b1111 : //memory byte operation 
                    begin
                        Out = A + B;
                        Of_temp2 = 1'b0;
                    end				
			4'b0100 : // Signed Multiplication
				begin
					Out = $signed(A) * $signed(B);
					Of_temp2 = 1'b0;
				end
			4'b0101 : // signed division
				begin
					Out[31:16] = $signed(A) % $signed(B);
					Out[15:0]  = $signed(A) / $signed(B);
				end
			4'b1101 : // SWAP
                begin
                    Out[31:16] = A;
                    Out[15:0]  = B;
                end
			4'b1110 : // MOVE
                begin
                    Out[31:16] = 0;
                    Out[15:0]  = B;
                end                                				
            default :
                    begin
                    Out = 0;
                    end
            
        endcase
            N = Out[15];
    end
    
endmodule
