`timescale 1ns / 1ps

/*
 Registers:
 x0 = zero
 x1 = ra
 x2 = sp
 x3 = gp
 x4 = tp
 x5 = t0
 x6 = t1
 x7 = t2
 x8 = s0/fp
 x9 = s1
 x10 = a0
 x11 = a1
 x12 = a2
 x13 = a3
 x14 = a4
 x15 = a5
 x16 = a6
 x17 = a7
 x18 = s2
 x19 = s3
 x20 = s4
 x21 = s5
 x22 = s6
 x23 = s7
 x24 = s8
 x25 = s9
 x26 = s10
 x27 = s11
 x28 = t3
 x29 = t4
 x30 = t5
 x31 = t6
 */


module riscv_tb;
   // Inputs
   reg clk;
   reg reset;

   // Output
   wire [31:0] pc_out;
   wire [31:0] instruction_out;

   // intermediate wires
   wire [31:0] pc;
   wire [31:0] fetched_instruction;
   wire        branch_taken;
   wire [31:0] branch_target;
   wire [6:0]  opcode;
   wire [2:0]  funct3;
   wire [6:0]  funct7;
   wire [4:0]  rd;
   wire [4:0]  rs1;
   wire [4:0]  rs2;
   wire [31:0] imm;
   wire [3:0]  alu_control;
   wire        regwrite_control;
   wire [31:0] alu_result;
   wire        zero_flag;
   wire [31:0] read_data1;
   wire [31:0] read_data2;

   riscv_processor core (
                         .clk(clk),
                         .reset(reset),
                         .pc_out(pc_out),
                         .instruction_out(instruction_out)
                         );

   assign pc = core.pc;
   assign fetched_instruction = core.fetched_instruction;
   assign branch_taken = core.branch_taken;
   assign branch_target = core.branch_target;
   assign opcode = core.opcode;
   assign funct3 = core.funct3;
   assign funct7 = core.funct7;
   assign rd = core.rd;
   assign rs1 = core.rs1;
   assign rs2 = core.rs2;
   assign imm = core.imm;
   assign alu_control = core.alu_control;
   assign regwrite_control = core.regwrite_control;
   assign alu_result = core.alu_result;
   assign regwrite_control = core.regwrite_control;
   assign alu_result = core.alu_result;
   assign zero_flag = core.zero_flag;
   assign read_data1 = core.read_data1;
   assign read_data2 = core.read_data2;

   integer     i;
   // define macro for printing the content of the memory
   // `define PRINT_REGISTER_CONTENTS \
   //    $display("===PRINTING REGISTER CONTENTS===\n"); \
   //    integer     i; \
   //    for (i = 0; i < 32; i = i + 1) begin \
   //       $display("REG: x%d = 0b%b", i, core.register_file_unit.reg_array[i]); \
   //    end \
   //    $display("===DONE PRINTING REGISTER CONTENTS===\n");

   // dump debugging/wave files
   initial begin
      $dumpfile("exe.vcd");
      $dumpvars(0, riscv_tb);
   end



   initial begin
      clk = 0;
      forever #5 clk = ~clk;
   end

   initial begin

      // monitor
      $monitor("Time = %0t\nPC = 0x%0h\nInstruction = 0x%0h\nFetched Instruction = 0x%0h\nOpcode = 0x%0h\nFunct3 = 0x%0h\nFunct7 = 0x%0h\nRD = 0x%0h\nRS1 = 0x%0h\nRS2 = 0x%0h\nIMM = 0x%0h\nALU Control = 0x%0h\nRegWrite Control = 0x%0h\nALU Result = 0x%0h\nZero Flag = 0x%0h\nRead Data1 = 0x%0h\nRead Data2 = 0x%0h\n",
               $time, pc_out, instruction_out, fetched_instruction, opcode, funct3, funct7, rd, rs1, rs2, imm, alu_control, regwrite_control, alu_result, zero_flag, read_data1, read_data2);

      reset = 1;
      #10;
      reset = 0;

      // wait for reset
      #50;

      // force set memory values
      core.register_file_unit.reg_array[5] = 32'h00000001;
      core.register_file_unit.reg_array[6] = 32'h00000002;

      // preload the instructions (R-Type)
      core.instruction_fetch_unit.instruction_memory[0] = 32'h005303b3; // ADD x7, x5, x6

      $display("===PRINTING INSTRUCTION MEMORY===");
      for (i = 0; i < 256; i = i + 1) begin
         if (core.instruction_fetch_unit.instruction_memory[i] != 0) begin
            $display("REG: x%d = 0x%0h", i, core.instruction_fetch_unit.instruction_memory[i]);
         end
      end
      $display("===DONE PRINTING INSTRUCTION MEMORY===\n");

      $display("===PRINTING REGISTER CONTENTS===");
      for (i = 0; i < 32; i = i + 1) begin
         if (core.register_file_unit.reg_array[i] != 0) begin
            $display("REG: x%d = 0x%0h", i, core.register_file_unit.reg_array[i]);
         end
      end
      $display("===DONE PRINTING REGISTER CONTENTS===\n");


      #100;

      $display("===PRINTING REGISTER CONTENTS===");
      for (i = 0; i < 32; i = i + 1) begin
         if (core.register_file_unit.reg_array[i] != 0) begin
            $display("REG: x%d = 0x%0h", i, core.register_file_unit.reg_array[i]);
         end
      end
      $display("===DONE PRINTING REGISTER CONTENTS===\n");

      $stop;
   end

endmodule // riscv_tb
