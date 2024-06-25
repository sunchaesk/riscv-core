`timescale 1ns / 1ps

module riscv_run;
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
      $dumpvars(0, riscv_run);
   end

   initial begin
      clk = 0;
      forever #5 clk = ~clk;
   end

   // declare the bin file to read
   initial begin
      $readmemb("/home/ck/Prog/Verilog/risc-core/asm/fib.b", core.instruction_fetch_unit.instruction_memory);

      $display("===PRINTING INSTRUCTION MEMORY===");
      for (i = 0; i < 256; i = i + 1) begin
         if (core.instruction_fetch_unit.instruction_memory[i] != 0) begin
            $display("INST-MEM: [%d] = 0x%0h", i, core.instruction_fetch_unit.instruction_memory[i]);
         end
      end
      $display("===DONE PRINTING INSTRUCTION MEMORY===\n");

      reset = 1;
      #10;
      reset = 0;
      #10;

      #200;

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
