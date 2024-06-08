`timescale 1ns / 1ps

module alu_tb;
   // declare inputs
   reg [31:0] in_a, in_b;
   reg [3:0]  alu_control;

   // declare outputs
   wire [31:0] alu_result;
   wire        zero_flag;

   ALU uut (
            .in_a(in_a),
            .in_b(in_b),
            .alu_control(alu_control),
            .alu_result(alu_result),
            .zero_flag(zero_flag)
            );

   initial begin
      // Display header
      $display("Time\tin_a\t\tin_b\t\talu_control\talu_result\tzero_flag");

      // Apply test vectors
      in_a = 32'd10; in_b = 32'd5; alu_control = 4'b0000; #10; // Test Bitwise-AND
      $display("%0d\t%h\t%h\t%b\t%h\t%b", $time, in_a, in_b, alu_control, alu_result, zero_flag);

      in_a = 32'd10; in_b = 32'd5; alu_control = 4'b0001; #10; // Test Bitwise-OR
      $display("%0d\t%h\t%h\t%b\t%h\t%b", $time, in_a, in_b, alu_control, alu_result, zero_flag);

      in_a = 32'd10; in_b = 32'd5; alu_control = 4'b0010; #10; // Test ADD
      $display("%0d\t%h\t%h\t%b\t%h\t%b", $time, in_a, in_b, alu_control, alu_result, zero_flag);

      in_a = 32'd10; in_b = 32'd5; alu_control = 4'b0011; #10; // Test SLL
      $display("%0d\t%h\t%h\t%b\t%h\t%b", $time, in_a, in_b, alu_control, alu_result, zero_flag);

      in_a = 32'd10; in_b = 32'd5; alu_control = 4'b0100; #10; // Test SUB
      $display("%0d\t%h\t%h\t%b\t%h\t%b", $time, in_a, in_b, alu_control, alu_result, zero_flag);

      in_a = 32'd10; in_b = 32'd2; alu_control = 4'b0101; #10; // Test SRL
      $display("%0d\t%h\t%h\t%b\t%h\t%b", $time, in_a, in_b, alu_control, alu_result, zero_flag);

      in_a = 32'd10; in_b = 32'd2; alu_control = 4'b0110; #10; // Test Multiply
      $display("%0d\t%h\t%h\t%b\t%h\t%b", $time, in_a, in_b, alu_control, alu_result, zero_flag);

      in_a = 32'd10; in_b = 32'd2; alu_control = 4'b0111; #10; // Test Bitwise-XOR
      $display("%0d\t%h\t%h\t%b\t%h\t%b", $time, in_a, in_b, alu_control, alu_result, zero_flag);

      in_a = 32'd10; in_b = 32'd20; alu_control = 4'b1000; #10; // Test SLT
      $display("%0d\t%h\t%h\t%b\t%h\t%b", $time, in_a, in_b, alu_control, alu_result, zero_flag);

      $finish;
   end
endmodule
