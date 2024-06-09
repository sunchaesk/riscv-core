`timescale 1ns / 1ps

module register_file_tb;
   reg clk;
   reg reset;
   reg [4:0] read_reg1;
   reg [4:0] read_reg2;
   reg [4:0] write_reg;
   reg [31:0] write_data;
   reg        reg_write;
   wire [31:0] read_data1;
   wire [31:0] read_data2;

   register_file REG (
                      .clk(clk),
                      .reset(reset),
                      .read_reg1(read_reg1),
                      .read_reg2(read_reg2),
                      .write_reg(write_reg),
                      .write_data(write_data),
                      .reg_write(reg_write),
                      .read_data1(read_data1),
                      .read_data2(read_data2)
                      );

   initial begin
      clk = 0;
      forever #5 clk = ~clk;
   end

   initial begin
      $monitor("Time :%0t | Reset: %b | read_reg1: %b | read_reg2: %b |
   write_reg: %b | write_data: %h | reg_write: %b | read_data1: %h | read_data2: %h",
               $time, reset, read_reg1, read_reg2, write_reg, write_data,
               reg_write, read_data1, read_data2);
   end


endmodule
