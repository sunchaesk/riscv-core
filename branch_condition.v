
/*
 branch_condition module is for deciding whether the IFU should branch (change the PC or not)

 Two conditions are checked:
 - If the instruction itself is a branching instruction: Only opcode that corresponds to B-type instruction will eval as 1.
 will turn the branch_instruction_control reg as 1
 - The actual branch condition is evaluated by the branch_condition unit.
 This is either return the branch_control flag as 1 or 0

 - Once both of these flags are evaluated, the branch_taken flag of the IFU which
 determines whether the branch should happen is only turned on if both the
 branch_instruction_control and branch_control flags are both 1.
 - branch_taken = branch_control && branch_instruction_control

 */

module branch_condition (
                         input [31:0] operand_a,
                         input [31:0] operand_b,
                         input [2:0]  branch_type,
                         output reg   branch_control
                         );

   always @(*) begin
      case (branch_type) // funct3
        3'b000: branch_control = (operand_a == operand_b); // BEQ
        3'b001: branch_control = (operand_a != operand_b); // BNE
        3'b100: branch_control = ($signed(operand_a) < $signed(operand_b)); // BLT
        3'b101: branch_control = ($signed(operand_a) >= $signed(operand_b)); // BGE
        3'b110: branch_control = (operand_a < operand_b); // BLTU
        3'b111: branch_control = (operand_a >= operand_b); // BGEU
        default: branch_control = 1'b0;
      endcase
   end

endmodule
