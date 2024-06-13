
module control (
                input [6:0]      opcode,
                input [2:0]      funct3,
                input [6:0]      funct7,
                output reg [3:0] alu_control,
                output reg       regwrite_control
                );

   always @(*) begin
      alu_control = 4'b1111; // default value
      regwrite_control = 1'b0;

      case(opcode)
        7'b0110011: begin // R-Type
           regwrite_control = 1;
           case({funct7[5], funct3})
             4'b0000: alu_control = 4'b0010; // ADD
             4'b1000: alu_control = 4'b0100; // SUB
             4'b0001: alu_control = 4'b0011; // SLL
             4'b0010: alu_control = 4'b1000; // SLT
             4'b0011: alu_control = 4'b0110; // SLTU
             4'b0100: alu_control = 4'b0111; // XOR
             4'b0101: alu_control = 4'b0101; // SRL
             4'b1101: alu_control = 4'b1001; // SRA
             4'b0110: alu_control = 4'b0001; // OR
             4'b0111: alu_control = 4'b0000; // AND
             default: alu_control = 4'b1111; // default value set to 1111
        end
      endcase
   end


endmodule
