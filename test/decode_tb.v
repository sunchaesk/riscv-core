`timescale 1ns / 1ps
`include "test_macro.vh"

module decoder_tb;
   // declare input/output
   reg [31:0] instruction;
   wire [6:0] opcode;
   wire [2:0] funct3;
   wire [6:0] funct7;
   wire [4:0] rd;
   wire [4:0] rs1;
   wire [4:0] rs2;
   wire [31:0] imm;

   decoder uut (
                .instruction(instruction),
                .opcode(opcode),
                .funct3(funct3),
                .funct7(funct7),
                .rd(rd),
                .rs1(rs1),
                .rs2(rs2),
                .imm(imm)
                );

   initial begin
      $dumpfile("exe.vcd");
      $dumpvars(0, decoder_tb);

      `assert(1'b0, 1'b0);

      instruction = 32'b00000000010000010000000010010011
; #10;
      $display("Instruction: %b", instruction);
      $display("Opcode: %b", opcode);
      $display("rd: %b", rd);
      $display("rs1: %b", rs1);
      $display("rs2: %b", rs2);
      $display("Immediate: %b", imm);
      $display("funct3: %b", funct3);
      $display("funct7: %b\n", funct7);

      instruction = 32'b00000000010000010101000010010011;
      #10;
      $display("Instruction: %b", instruction);
      $display("Opcode: %b", opcode);
      $display("rd: %b", rd);
      $display("rs1: %b", rs1);
      $display("rs2: %b", rs2);
      $display("Immediate: %b", imm);
      $display("funct3: %b", funct3);
      $display("funct7: %b\n", funct7);

      $stop;
   end

   // Monitor the output
   // initial begin
   //    $monitor("Time: %0d, Instruction: %b, Opcode: %b, rs: %b, rt: %b, Immediate: %b", $time, instruction, opcode, rs, rt, immediate);
   // end

endmodule
