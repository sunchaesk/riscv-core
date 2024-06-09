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

      #10;
      reset = 0;

      #50;

      branch_target = 32'h00000010;
      branch_taken = 1;
      #10;
      branch_taken = 0;

      #50;

      branch_target = 32'h00000020;
      branch_taken = 1;
      #10;
      branch_taken = 0;

      #50;

      $stop;
   end


endmodule
