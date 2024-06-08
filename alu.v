
/*
zero_flag is set to zero if the alu_result is zero
*/

module ALU (
            input [31:0] in_a, in_b,
            input [3:0]  alu_control,
            output reg[31:0] alu_result,
            output reg zero_flag
            );

   always @(*) begin
      case (alu_control)
        4'b0000: alu_result = in_a + in_b;


    end

endmodule // ALU
