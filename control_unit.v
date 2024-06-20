// NOTE: imm_control is used for whether immediate should be used
module control (
                input [6:0]      opcode,
                input [2:0]      funct3,
                input [6:0]      funct7,
                output reg [3:0] alu_control,
                output reg       regwrite_control,
                output reg       imm_control,
                output reg       mem_read_control,
                output reg       mem_write_control
                );

   always @(*) begin
      alu_control = 4'b1111; // default value
      regwrite_control = 1'b0;
      mem_read_control = 1'b0;
      mem_write_control = 1'b0;
      imm_control = 1'b0;
      case(opcode)
        7'b0110011: begin // R-Type
           regwrite_control = 1;
           imm_control = 0;
           mem_read_control = 0;
           mem_write_control = 0;
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
           endcase
        end
        7'b0010011: begin // I-Type
           regwrite_control = 1;
           imm_control = 1;
           mem_read_control = 0;
           mem_write_control = 0;
           case({funct7[5], funct3})
             4'b0000: alu_control = 4'b0010; // ADDI
             4'b0001: alu_control = 4'b0011; // SLLI
             4'b0010: alu_control = 4'b1000; // SLTI
             4'b0011: alu_control = 4'b0110; // SLTUI
             4'b0100: alu_control = 4'b0111; // XORI
             4'b0101: alu_control = 4'b0101; // SRLI
             4'b1101: alu_control = 4'b1001; // SRAI
             4'b0110: alu_control = 4'b0001; // ORI
             4'b0111: alu_control = 4'b0000; // ANDI
             default: alu_control = 4'b1111; // default value
           endcase
        end
        7'b0000011: begin // Load instructions
           regwrite_control = 1;
           imm_control = 1;
           mem_read_control = 1;
           mem_write_control = 0;
           case(funct3)
             3'b000,
             3'b001,
             3'b010,
             3'b100,
             3'b101: alu_control = 4'b0010;
           endcase
        end
      endcase
   end
endmodule
