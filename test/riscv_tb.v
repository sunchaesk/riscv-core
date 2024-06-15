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

      core.instruction_fetch_unit.instruction_memory[0] = 32'h11111111;
      core.instruction_fetch_unit.instruction_memory[1] = 32'h22222222;
      core.instruction_fetch_unit.instruction_memory[2] = 32'h33333333;
      core.instruction_fetch_unit.instruction_memory[3] = 32'h44444444;
      core.instruction_fetch_unit.instruction_memory[4] = 32'h55555555;
      core.instruction_fetch_unit.instruction_memory[5] = 32'h66666666;
      core.instruction_fetch_unit.instruction_memory[6] = 32'h77777777;
      core.instruction_fetch_unit.instruction_memory[7] = 32'h88888888;
      core.instruction_fetch_unit.instruction_memory[8] = 32'h99999999;
      core.instruction_fetch_unit.instruction_memory[9] = 32'hAAAAAAAA;
      core.instruction_fetch_unit.instruction_memory[10] = 32'hBBBBBBBB;
      core.instruction_fetch_unit.instruction_memory[11] = 32'hCCCCCCCC;

      $monitor("Time = %0t\nPC = 0x%0h\nINSTRUCTION = 0x%0h", $time, pc, instruction);

      reset = 1;
      #10;
      reset = 0;

      #50;

      $stop;
   end
   

endmodule
