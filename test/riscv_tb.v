`timescale 1ns / 1ps

// testing for R instruction
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
   wire        d_branch_taken;

   wire [6:0]  d_opcode;
   wire [2:0]  d_funct3;
   wire [6:0]  d_funct7;
   wire [4:0]  d_rd;
   wire [4:0]  d_rs1;
   wire [4:0]  d_rs2;
   wire [31:0] d_imm;
   wire [2:0]  d_imm_type;

   wire [3:0]  d_alu_control;
   wire        d_regwrite_control;
   wire        d_imm_control;
   wire        d_mem_read_control;
   wire        d_mem_write_control;
   wire        d_branch_instruction_control;
   wire [2:0]  d_branch_type;
   wire        d_jal_control;
   wire        d_jalr_control;

   wire        d_branch_control;

   wire [31:0] d_branch_target;

   wire [31:0] d_alu_result;
   wire        d_zero_flag;

   wire [31:0] d_mem_data_in;
   wire [31:0] d_mem_address;
   wire [31:0] d_mem_data_out;

   wire [31:0] d_read_data1;
   wire [31:0] d_read_data2;

   wire [31:0] d_reg_write_data;

   wire [31:0] d_operand_a;
   wire [31:0] d_operand_b;

   wire        d_jump_taken;
   wire [31:0] d_jump_target;


   assign d_pc = core.pc;
   assign d_instruction = core.fetched_instruction;
   assign d_branch_taken = core.branch_taken;

   assign d_opcode = core.opcode;
   assign d_funct3 = core.funct3;
   assign d_funct7 = core.funct7;
   assign d_rd = core.rd;
   assign d_rs1 = core.rs1;
   assign d_rs2 = core.rs2;
   assign d_imm = core.imm;
   assign d_imm_type = core.imm_type;

   assign d_alu_control = core.alu_control;
   assign d_regwrite_control = core.regwrite_control;
   assign d_imm_control = core.imm_control;
   assign d_mem_read_control = core.mem_read_control;
   assign d_mem_write_control = core.mem_write_control;
   assign d_branch_instruction_control = core.branch_instruction_control;
   assign d_branch_type = core.branch_type;
   assign d_jal_control = core.jal_control;
   assign d_jalr_control = core.jalr_control;

   assign d_branch_control = core.branch_control;

   assign d_branch_target = core.branch_target;

   assign d_alu_result = core.alu_result;
   assign d_zero_flag = core.zero_flag;

   assign d_mem_data_in = core.mem_data_in;
   assign d_mem_address = core.mem_address;
   assign d_mem_data_out = core.mem_data_out;

   assign d_read_data1 = core.read_data1;
   assign d_read_data2 = core.read_data2;

   assign d_reg_write_data = core.reg_write_data;

   assign d_operand_a = core.operand_a;
   assign d_operand_b = core.operand_b;

   assign d_jump_taken = core.jump_taken;
   assign d_jump_target = core.jump_target;

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


   // Test for LUI and AUIPC
   initial begin

      // load instruction
      core.instruction_fetch_unit.instruction_memory[1] = 32'h0dcba2b7;
      core.instruction_fetch_unit.instruction_memory[2] = 32'h0dcba317;

      $display("===PRINTING INSTRUCTION MEMORY===");
      for (i = 0; i < 256; i = i + 1) begin
         if (core.instruction_fetch_unit.instruction_memory[i] != 0) begin
            $display("INST-MEM: [%d] = 0x%0h", i, core.instruction_fetch_unit.instruction_memory[i]);
         end
      end
      $display("===DONE PRINTING INSTRUCTION MEMORY===\n");


      // reset
      reset = 1;
      #10;
      reset = 0;
      #10;

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

   // Test for JALR instruction
   // initial begin

   //    // load instructions
   //    core.instruction_fetch_unit.instruction_memory[1] = 32'h00c40413; // addi x8, x8, 12
   //    core.instruction_fetch_unit.instruction_memory[2] = 32'h008402e7; // jalr x5, 8(x8)

   //    $monitor("Time = %0t\nPC = 0x%0h\nINSTRUCTION = 0x%0h\nBRANCH_TAKEN = 0x%0h\nOPCODE = 0x%0h\nFUNCT3 = 0x%0h\nFUNCT7 = 0x%0h\nRD = 0x%0h\nRS1 = 0x%0h\nRS2 = 0x%0h\nIMM = 0x%0h\nIMM_TYPE = 0x%0h\nALU_CONTROL = 0x%0h\nREGWRITE_CONTROL = 0x%0h\nIMM_CONTROL = 0x%0h\nMEM_READ_CONTROL = 0x%0h\nMEM_WRITE_CONTROL = 0x%0h\nBRANCH_INSTRUCTION_CONTROL = 0x%0h\nBRANCH_TYPE = 0x%0h\nJAL_CONTROL = 0x%0h\nJALR_CONTROL = 0x%0h\nBRANCH_CONTROL = 0x%0h\nBRANCH_TARGET = 0x%0h\nALU_RESULT = 0x%0h\nZERO_FLAG = 0x%0h\nMEM_DATA_IN = 0x%0h\nMEM_ADDRESS = 0x%0h\nMEM_DATA_OUT = 0x%0h\nREAD_DATA1 = 0x%0h\nREAD_DATA2 = 0x%0h\nREG_WRITE_DATA = 0x%0h\nOPERAND_A = 0x%0h\nOPERAND_B = 0x%0h\nJUMP_TAKEN = 0x%0h\nJUMP_TARGET = 0x%0h\n\n",
   //             $time, d_pc, d_instruction, d_branch_taken, d_opcode, d_funct3, d_funct7, d_rd, d_rs1, d_rs2, d_imm, d_imm_type, d_alu_control, d_regwrite_control, d_imm_control, d_mem_read_control, d_mem_write_control, d_branch_instruction_control, d_branch_type, d_jal_control, d_jalr_control, d_branch_control, d_branch_target, d_alu_result, d_zero_flag, d_mem_data_in, d_mem_address, d_mem_data_out, d_read_data1, d_read_data2, d_reg_write_data, d_operand_a, d_operand_b, d_jump_taken, d_jump_target);


   //    $display("===PRINTING INSTRUCTION MEMORY===");
   //    for (i = 0; i < 256; i = i + 1) begin
   //       if (core.instruction_fetch_unit.instruction_memory[i] != 0) begin
   //          $display("INST-MEM: [%d] = 0x%0h", i, core.instruction_fetch_unit.instruction_memory[i]);
   //       end
   //    end
   //    $display("===DONE PRINTING INSTRUCTION MEMORY===\n");

   //    // reset
   //    reset = 1;
   //    #10;
   //    reset = 0;
   //    #10;

   //    #10;
   //    $display("===PRINTING REGISTER CONTENTS===");
   //    for (i = 0; i < 32; i = i + 1) begin
   //       if (core.register_file_unit.reg_array[i] != 0) begin
   //          $display("REG: x%d = 0x%0h", i, core.register_file_unit.reg_array[i]);
   //       end
   //    end
   //    $display("===DONE PRINTING REGISTER CONTENTS===\n");

   //    #60;

   //    $display("===PRINTING REGISTER CONTENTS===");
   //    for (i = 0; i < 32; i = i + 1) begin
   //       if (core.register_file_unit.reg_array[i] != 0) begin
   //          $display("REG: x%d = 0x%0h", i, core.register_file_unit.reg_array[i]);
   //       end
   //    end
   //    $display("===DONE PRINTING REGISTER CONTENTS===\n");

   //    $stop;
   // end

   // Test for JAL instructions
   // initial begin

   //    // load instructions
   //    core.instruction_fetch_unit.instruction_memory[1] = 32'h00a40413; // addi x8, x8, 10
   //    core.instruction_fetch_unit.instruction_memory[2] = 32'h00c002ef; // jal x5, 12
   //    core.instruction_fetch_unit.instruction_memory[3] = 32'h06430313; // addi x6, x6, 100 (should be skipped)
   //    core.instruction_fetch_unit.instruction_memory[4] = 32'h06438393; // addi x7, x7, 100 (should be skipped)
   //    core.instruction_fetch_unit.instruction_memory[5] = 32'h00a40413; // addi x8, x8, 10

   //    $monitor("Time = %0t\nPC = 0x%0h\nINSTRUCTION = 0x%0h\nBRANCH_TAKEN = 0x%0h\nOPCODE = 0x%0h\nFUNCT3 = 0x%0h\nFUNCT7 = 0x%0h\nRD = 0x%0h\nRS1 = 0x%0h\nRS2 = 0x%0h\nIMM = 0x%0h\nIMM_TYPE = 0x%0h\nALU_CONTROL = 0x%0h\nREGWRITE_CONTROL = 0x%0h\nIMM_CONTROL = 0x%0h\nMEM_READ_CONTROL = 0x%0h\nMEM_WRITE_CONTROL = 0x%0h\nBRANCH_INSTRUCTION_CONTROL = 0x%0h\nBRANCH_TYPE = 0x%0h\nJAL_CONTROL = 0x%0h\nJALR_CONTROL = 0x%0h\nBRANCH_CONTROL = 0x%0h\nBRANCH_TARGET = 0x%0h\nALU_RESULT = 0x%0h\nZERO_FLAG = 0x%0h\nMEM_DATA_IN = 0x%0h\nMEM_ADDRESS = 0x%0h\nMEM_DATA_OUT = 0x%0h\nREAD_DATA1 = 0x%0h\nREAD_DATA2 = 0x%0h\nREG_WRITE_DATA = 0x%0h\nOPERAND_A = 0x%0h\nOPERAND_B = 0x%0h\nJUMP_TAKEN = 0x%0h\nJUMP_TARGET = 0x%0h\n\n",
   //             $time, d_pc, d_instruction, d_branch_taken, d_opcode, d_funct3, d_funct7, d_rd, d_rs1, d_rs2, d_imm, d_imm_type, d_alu_control, d_regwrite_control, d_imm_control, d_mem_read_control, d_mem_write_control, d_branch_instruction_control, d_branch_type, d_jal_control, d_jalr_control, d_branch_control, d_branch_target, d_alu_result, d_zero_flag, d_mem_data_in, d_mem_address, d_mem_data_out, d_read_data1, d_read_data2, d_reg_write_data, d_operand_a, d_operand_b, d_jump_taken, d_jump_target);

   //    $display("===PRINTING INSTRUCTION MEMORY===");
   //    for (i = 0; i < 256; i = i + 1) begin
   //       if (core.instruction_fetch_unit.instruction_memory[i] != 0) begin
   //          $display("INST-MEM: [%d] = 0x%0h", i, core.instruction_fetch_unit.instruction_memory[i]);
   //       end
   //    end
   //    $display("===DONE PRINTING INSTRUCTION MEMORY===\n");

   //    // reset
   //    reset = 1;
   //    #10;
   //    reset = 0;
   //    #10;

   //    #60;

   //    $display("===PRINTING REGISTER CONTENTS===");
   //    for (i = 0; i < 32; i = i + 1) begin
   //       if (core.register_file_unit.reg_array[i] != 0) begin
   //          $display("REG: x%d = 0x%0h", i, core.register_file_unit.reg_array[i]);
   //       end
   //    end
   //    $display("===DONE PRINTING REGISTER CONTENTS===\n");

   //    $stop;
// end

// Test for branch (B) instructions
// initial begin

//    // load instructions
//    core.instruction_fetch_unit.instruction_memory[1] = 32'h00628463; // beq x5, x6, 8
//    // core.instruction_fetch_unit.instruction_memory[1] = 32'h00528433; // add x8, x5, x5
//    // core.instruction_fetch_unit.instruction_memory[1] = 32'h00628663; // beq x5, x6, 12
//    // core.instruction_fetch_unit.instruction_memory[2] = 32'h006282b3; // add x5, x5, x6
//    core.instruction_fetch_unit.instruction_memory[2] = 32'h00528293; // addi x5, x5, 5
//    core.instruction_fetch_unit.instruction_memory[3] = 32'h06430313; // addi x6, x6, 100
//    core.instruction_fetch_unit.instruction_memory[4] = 32'h00629863; // bne x5, x6, 16
//    core.instruction_fetch_unit.instruction_memory[5] = 32'h00728293; // addi x5, x5, 7
//    core.instruction_fetch_unit.instruction_memory[6] = 32'h00728293; // addi x5, x5, 7

//    $monitor("Time = %0t\nPC = 0x%0h\nINSTRUCTION = 0x%0h\nBRANCH_TAKEN = 0x%0h\nOPCODE = 0x%0h\nFUNCT3 = 0x%0h\nFUNCT7 = 0x%0h\nRD = 0x%0h\nRS1 = 0x%0h\nRS2 = 0x%0h\nIMM = 0x%0h\nIMM_TYPE = 0x%0h\nALU_CONTROL = 0x%0h\nREGWRITE_CONTROL = 0x%0h\nIMM_CONTROL = 0x%0h\nMEM_READ_CONTROL = 0x%0h\nMEM_WRITE_CONTROL = 0x%0h\nBRANCH_INSTRUCTION_CONTROL = 0x%0h\nBRANCH_TYPE = 0x%0h\nBRANCH_CONTROL = 0x%0h\nBRANCH_TARGET = 0x%0h\nALU_RESULT = 0x%0h\nZERO_FLAG = 0x%0h\nMEM_DATA_IN = 0x%0h\nMEM_ADDRESS = 0x%0h\nMEM_DATA_OUT = 0x%0h\nREAD_DATA1 = 0x%0h\nREAD_DATA2 = 0x%0h\nREG_WRITE_DATA = 0x%0h\nOPERAND_A = 0x%0h\nOPERAND_B = 0x%0h\n\n",
//             $time, d_pc, d_instruction, d_branch_taken, d_opcode, d_funct3, d_funct7, d_rd, d_rs1, d_rs2, d_imm, d_imm_type, d_alu_control, d_regwrite_control, d_imm_control, d_mem_read_control, d_mem_write_control, d_branch_instruction_control, d_branch_type, d_branch_control, d_branch_target, d_alu_result, d_zero_flag, d_mem_data_in, d_mem_address, d_mem_data_out, d_read_data1, d_read_data2, d_reg_write_data, d_operand_a, d_operand_b);

//    $display("===PRINTING INSTRUCTION MEMORY===");
//    for (i = 0; i < 256; i = i + 1) begin
//       if (core.instruction_fetch_unit.instruction_memory[i] != 0) begin
//          $display("INST-MEM: [%d] = 0x%0h", i, core.instruction_fetch_unit.instruction_memory[i]);
//       end
//    end
//    $display("===DONE PRINTING INSTRUCTION MEMORY===\n");

//    // reset
//    reset = 1;
//    #10;
//    reset = 0;

//    core.register_file_unit.reg_array[5] = 32'h00000003;
//    core.register_file_unit.reg_array[6] = 32'h00000003;
//    #10;

//    // load register values
//    // print register content
//    $display("===PRINTING REGISTER CONTENTS===");
//    for (i = 0; i < 32; i = i + 1) begin
//       if (core.register_file_unit.reg_array[i] != 0) begin
//          $display("REG: x%d = 0x%0h", i, core.register_file_unit.reg_array[i]);
//       end
//    end
//    $display("===DONE PRINTING REGISTER CONTENTS===\n");

//    #50;


//    $display("===PRINTING REGISTER CONTENTS===");
//    for (i = 0; i < 32; i = i + 1) begin
//       if (core.register_file_unit.reg_array[i] != 0) begin
//          $display("REG: x%d = 0x%0h", i, core.register_file_unit.reg_array[i]);
//       end
//    end
//    $display("===DONE PRINTING REGISTER CONTENTS===\n");

//    $stop;
// end


/* TEST for S-type instructions (save)
 // TEST for store instructions (S type)
 initial begin

 // load instructions
 core.instruction_fetch_unit.instruction_memory[0] = 32'h00530223; // sb x5, 4(x6)
 core.instruction_fetch_unit.instruction_memory[1] = 32'h00742023; // sw x7, 0(x8)


 $monitor("Time = %0t\nPC = 0x%0h\nINSTRUCTION = 0x%0h\nOPCODE = 0x%0h\nFUNCT3 = 0x%0h\nFUNCT7 = 0x%0h\nRD = 0x%0h\nRS1 = 0x%0h\nRS2 = 0x%0h\nIMM = 0x%0h\nALU_CONTROL = 0x%0h\nREGWRITE_CONTROL = 0x%0h\nIMM_CONTROL = 0x%0h\nMEM_READ_CONTROL = 0x%0h\nMEM_WRITE_CONTROL = 0x%0h\nALU_RESULT = 0x%0h\nZERO_FLAG = 0x%0h\nMEM_DATA_IN = 0x%0h\nMEM_ADDRESS = 0x%0h\nMEM_DATA_OUT = 0x%0h\nREAD_DATA1 = 0x%0h\nREAD_DATA2 = 0x%0h\nREG_WRITE_DATA = 0x%0h\nOPERAND_A = 0x%0h\nOPERAND_B = 0x%0h\n\n",
 $time, d_pc, d_instruction, d_opcode, d_funct3, d_funct7, d_rd, d_rs1, d_rs2, d_imm, d_alu_control, d_regwrite_control, d_imm_control, d_mem_read_control, d_mem_write_control, d_alu_result, d_zero_flag, d_mem_data_in, d_mem_address, d_mem_data_out, d_read_data1, d_read_data2, d_reg_write_data, d_operand_a, d_operand_b);


 $display("===PRINTING INSTRUCTION MEMORY===");
 for (i = 0; i < 256; i = i + 1) begin
 if (core.instruction_fetch_unit.instruction_memory[i] != 0) begin
 $display("INST-MEM: [%d] = 0x%0h", i, core.instruction_fetch_unit.instruction_memory[i]);
         end
      end
 $display("===DONE PRINTING INSTRUCTION MEMORY===\n");

 // reset
 reset = 1;
 #10;
 reset = 0;
 #10;

 // load register values
 core.register_file_unit.reg_array[5] = 32'hAAAAAAAA;
 core.register_file_unit.reg_array[6] = 32'h00000004; // 4 + 4 mem address
 core.register_file_unit.reg_array[7] = 32'hBBBBBBBB;
 core.register_file_unit.reg_array[8] = 32'h0000000C; // 12 mem address
 // print register content
 $display("===PRINTING REGISTER CONTENTS===");
 for (i = 0; i < 32; i = i + 1) begin
 if (core.register_file_unit.reg_array[i] != 0) begin
 $display("REG: x%d = 0x%0h", i, core.register_file_unit.reg_array[i]);
         end
      end
 $display("===DONE PRINTING REGISTER CONTENTS===\n");

 #50;

 // print memory values
 $display("===PRINING MEMORY VALUES===");
 for (i = 0; i < 256; i = i + 1) begin
 if (core.memory_unit.memory[i] != 0) begin
 $display("MEMORY [%d] = 0x%0h", i, core.memory_unit.memory[i]);
         end
      end
 $display("===DONE PRINTING MEMORY VALUES===");


 $stop;
   end
 */


/*
 // TEST for load instructions (I type)
 initial begin

 // load instructions
 core.instruction_fetch_unit.instruction_memory[0] = 32'h0002a303; //  lw x6, 0(x5)
 core.instruction_fetch_unit.instruction_memory[1] = 32'h00c28383; // lb x7, 12(x5)
 core.instruction_fetch_unit.instruction_memory[2] = 32'h00450403; // lb x8, 4(x10)

 $monitor("Time = %0t\nPC = 0x%0h\nINSTRUCTION = 0x%0h\nOPCODE = 0x%0h\nFUNCT3 = 0x%0h\nFUNCT7 = 0x%0h\nRD = 0x%0h\nRS1 = 0x%0h\nRS2 = 0x%0h\nIMM = 0x%0h\nALU_CONTROL = 0x%0h\nREGWRITE_CONTROL = 0x%0h\nALU_RESULT = 0x%0h\nZERO_FLAG = 0x%0h\nMEM_DATA_IN = 0x%0h\nMEM_ADDRESS = 0x%0h\nMEM_DATA_OUT = 0x%0h\nREAD_DATA1 = 0x%0h\nREAD_DATA2 = 0x%0h\nREG_WRITE_DATA = 0x%0h\nOPERAND_A = 0x%0h\nOPERAND_B = 0x%0h\n\n",
 $time, d_pc, d_instruction, d_opcode, d_funct3, d_funct7, d_rd, d_rs1, d_rs2, d_imm, d_alu_control, d_regwrite_control, d_alu_result, d_zero_flag, d_mem_data_in, d_mem_address, d_mem_data_out, d_read_data1, d_read_data2, d_reg_write_data, d_operand_a, d_operand_b);

 $display("===PRINTING INSTRUCTION MEMORY===");
 for (i = 0; i < 256; i = i + 1) begin
 if (core.instruction_fetch_unit.instruction_memory[i] != 0) begin
 $display("REG: x%d = 0x%0h", i, core.instruction_fetch_unit.instruction_memory[i]);
         end
      end
 $display("===DONE PRINTING INSTRUCTION MEMORY===\n");

 reset = 1;
 #10;
 reset = 0;
 #10;

 // load register values
 // print register values
 $display("===PRINTING REGISTER CONTENTS===");
 for (i = 0; i < 32; i = i + 1) begin
 if (core.register_file_unit.reg_array[i] != 0) begin
 $display("REG: x%d = 0x%0h", i, core.register_file_unit.reg_array[i]);
         end
      end
 $display("===DONE PRINTING REGISTER CONTENTS===\n");

 // load memory values
 core.memory_unit.memory[0] = 32'h11111111;
 core.memory_unit.memory[1] = 32'h22222222;
 core.memory_unit.memory[2] = 32'h33333333;
 core.memory_unit.memory[3] = 32'h44444444;
 core.memory_unit.memory[4] = 32'h55555555;
 core.memory_unit.memory[5] = 32'h66666666;
 core.memory_unit.memory[6] = 32'h77777777;
 core.memory_unit.memory[7] = 32'h88888888;
 core.memory_unit.memory[8] = 32'h99999999;
 core.memory_unit.memory[9] = 32'hAAAAAAAA;
 core.memory_unit.memory[10] = 32'hBBBBBBBB;
 core.memory_unit.memory[11] = 32'hCCCCCCCC;
 core.memory_unit.memory[12] = 32'hDDDDDDDD;
 core.memory_unit.memory[13] = 32'hEEEEEEEE;
 // print memory values
 $display("===PRINTING MEMORY VALUES===");
 for (i = 0; i < 256; i = i + 1) begin
 if (core.memory_unit.memory[i] != 0) begin
 $display("MEMORY [%d] = 0x%0h", i, core.memory_unit.memory[i]);
         end
      end

 // let the CPU run for a bit
 #50;

 // check values of the register
 $display("===PRINTING REGISTER CONTENTS===");
 for (i = 0; i < 32; i = i + 1) begin
 if (core.register_file_unit.reg_array[i] != 0) begin
 $display("REG: x%d = 0x%0h", i, core.register_file_unit.reg_array[i]);
         end
      end
 $display("===DONE PRINTING REGISTER CONTENTS===\n");

 $stop;
   end
 */
// TEST for I-Type -> immediate instructions
/*
 initial begin

 // load instructions manually
 core.instruction_fetch_unit.instruction_memory[0] = 32'h00a28393; // ADDI t2, x5, 10
 core.instruction_fetch_unit.instruction_memory[1] = 32'h00436613; // ORI a2, t1, 4

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
 #10;

 // preset register values
 core.register_file_unit.reg_array[5] = 32'h00000001;
 core.register_file_unit.reg_array[6] = 32'h00000002;

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
 */

/* TEST for R-Type INST
 initial begin

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
 #10;

 // preset the values of the registers
 core.register_file_unit.reg_array[5] = 32'h00000001;
 core.register_file_unit.reg_array[6] = 32'h00000002;
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
 */

endmodule
