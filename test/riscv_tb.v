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

   // Outputs
   wire [31:0] pc;
   wire [31:0] instruction;

   // debug
   integer     i;

   wire [31:0] d_pc;
   wire [31:0] d_instruction;

   wire [6:0]                          d_opcode;
   wire [2:0]                          d_funct3;
   wire [6:0]                          d_funct7;
   wire [4:0]                          d_rd;
   wire [4:0]                          d_rs1;
   wire [4:0]                          d_rs2;
   wire [31:0]                         d_imm;

   wire [3:0]                          d_alu_control;
   wire                                d_regwrite_control;

   wire [31:0]                         d_alu_result;
   wire                                d_zero_flag;

   wire [31:0]                         d_read_data1;
   wire [31:0]                         d_read_data2;


   assign d_pc = core.pc;
   assign d_instruction = core.fetched_instruction;

   assign d_opcode = core.opcode;
   assign d_funct3 = core.funct3;
   assign d_funct7 = core.funct7;
   assign d_rd = core.rd;
   assign d_rs1 = core.rs1;
   assign d_rs2 = core.rs2;
   assign d_imm = core.imm;

   assign d_alu_control = core.alu_control;
   assign d_regwrite_control = core.regwrite_control;

   assign d_alu_result = core.alu_result;
   assign d_zero_flag = core.zero_flag;

   assign d_read_data1 = core.read_data1;
   assign d_read_data2 = core.read_data2;

   riscv_processor core (
                         .clk(clk),
                         .reset(reset),
                         .pc_out(pc),
                         .instruction_out(instruction)
                         );

   // waveform stuff
   initial begin
      $dumpfile("exe.vcd");
      $dumpvars(0, riscv_tb);
   end

   initial begin
      clk = 0;
      forever #5 clk = ~clk;
   end

   initial begin
      // preset the values of the registers
      core.register_file_unit.reg_array[5] = 32'h00000001;
      core.register_file_unit.reg_array[6] = 32'h00000002;

      // load instructions manually
      core.instruction_fetch_unit.instruction_memory[0] = 32'h005303b3; // ADD t2, t1, t0
      core.instruction_fetch_unit.instruction_memory[1] = 32'h00628633; // ADD a2, t0, t1
      // core.instruction_fetch_unit.instruction_memory[2] = 32'h33333333;
      // core.instruction_fetch_unit.instruction_memory[3] = 32'h44444444;
      // core.instruction_fetch_unit.instruction_memory[4] = 32'h55555555;
      // core.instruction_fetch_unit.instruction_memory[5] = 32'h66666666;
      // core.instruction_fetch_unit.instruction_memory[6] = 32'h77777777;
      // core.instruction_fetch_unit.instruction_memory[7] = 32'h88888888;
      // core.instruction_fetch_unit.instruction_memory[8] = 32'h99999999;
      // core.instruction_fetch_unit.instruction_memory[9] = 32'hAAAAAAAA;
      // core.instruction_fetch_unit.instruction_memory[10] = 32'hBBBBBBBB;
      // core.instruction_fetch_unit.instruction_memory[11] = 32'hCCCCCCCC;

      $monitor("Time = %0t\nPC = 0x%0h\nINSTRUCTION = 0x%0h\nOPCODE = 0x%0h\nFUNCT3 = 0x%0h\nFUNCT7 = 0x%0h\nRD = 0x%0h\nRS1 = 0x%0h\nRS2 = 0x%0h\nIMM = 0x%0h\nALU_CONTROL = 0x%0h\nREGWRITE_CONTROL = 0x%0h\nALU_RESULT = 0x%0h\nZERO_FLAG = 0x%0h\nREAD_DATA1 = 0x%0h\nREAD_DATA2 = 0x%0h\n\n",
               $time, d_pc, d_instruction, d_opcode, d_funct3, d_funct7, d_rd, d_rs1, d_rs2, d_imm, d_alu_control, d_regwrite_control, d_alu_result, d_zero_flag, d_read_data1, d_read_data2);


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

      reset = 1;
      #10;
      reset = 0;

      #50;

      $display("===PRINTING REGISTER CONTENTS===");
      for (i = 0; i < 32; i = i + 1) begin
         if (core.register_file_unit.reg_array[i] != 0) begin
            $display("REG: x%d = 0x%0h", i, core.register_file_unit.reg_array[i]);
         end
      end
      $display("===DONE PRINTING REGISTER CONTENTS===\n");

      $stop;
   end
   

endmodule
