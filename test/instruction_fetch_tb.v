`timescale 1ns / 1ps

// `include "instruction_fetch.v"

module instruction_fetch_tb;

   // instantiate signals
   reg clk;
   reg reset;
   reg [31:0] branch_target;
   reg        branch_taken;
   wire [31:0] pc;
   wire [31:0] instruction;

   IFU uut (
            .clk(clk),
            .reset(reset),
            .branch_target(branch_target),
            .branch_taken(branch_taken),
            .pc(pc),
            .instruction(instruction)
            );

   initial begin
      clk = 0;
      forever #5 clk = ~clk;
   end

   initial begin
      $monitor("Time: %0t | Reset: %b | Branch Target: %h | Branch Taken: %b | PC: %h | Instruction: %h\n",
               $time, reset, branch_target, branch_taken, pc, instruction);
   end

   initial begin
      reset = 1;
      branch_target = 32'b0;
      branch_taken = 0;

      // load the instruction memory
      uut.instruction_memory[0] = 32'h11111111;
      uut.instruction_memory[1] = 32'h22222222;
      uut.instruction_memory[2] = 32'h33333333;
      uut.instruction_memory[3] = 32'h44444444;
      uut.instruction_memory[4] = 32'h55555555;
      uut.instruction_memory[5] = 32'h66666666;
      uut.instruction_memory[6] = 32'h77777777;
      uut.instruction_memory[7] = 32'h88888888;
      uut.instruction_memory[8] = 32'h99999999;
      uut.instruction_memory[9] = 32'hAAAAAAAA;
      uut.instruction_memory[10] = 32'hBBBBBBBB;
      uut.instruction_memory[11] = 32'hCCCCCCCC;

      #10;
      reset = 0;

      #20;

      branch_target = 32'h00000000;
      branch_taken = 1;
      #10;
      branch_taken = 0;


      #30;

      // branch_target = 32'h00000020;
      // branch_taken = 1;
      // #10;
      // branch_taken = 0;

      // #50;

      $stop;
   end


endmodule
