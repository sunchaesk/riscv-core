
/*
 zero_flag is set to zero if the alu_result is zero
 ALU Control lines | Function
 -----------------------------
 0000    Bitwise-AND
 0001    Bitwise-OR
 0010    Add (A+B)
 0100    Subtract (A-B)
 1000    Set on less than
 0011    Shift left logical
 0101    Shift right logical
 0110    Multiply
 0111    Bitwise-XOR
 */

module ALU (
            input [31:0]      in_a, in_b,
            input [3:0]       alu_control,
            output reg [31:0] alu_result,
            output reg        zero_flag
            );

   always @(*) begin
      case (alu_control)
        4'b0000: alu_result = in_a & in_b;
        4'b0001: alu_result = in_a | in_b;
        4'b0010: alu_result = in_a + in_b;
        4'b0100: alu_result = in_a - in_b;
        4'b1000: alu_result = (in_a < in_b) ? 32'b1 : 32'b0;
        4'b0011: alu_result = in_a << in_b;
        4'b0101: alu_result = in_a >> in_b;
        4'b0110: alu_result = in_a * in_b;
        4'b0111: alu_result = in_a ^ in_b;
      endcase

      if (alu_result == 0)
        zero_flag = 1'b1;
      else
        zero_flag = 1'b0;

   end
endmodule // ALU
