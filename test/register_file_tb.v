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
      $dumpfile("exe.vcd");
      $dumpvars(0, register_file_tb);
   end
   
   initial begin
      clk = 0;
      forever #5 clk = ~clk;
   end

   initial begin
      $monitor("Time :%0t | Reset: %b | read_reg1: %b | read_reg2: %b | write_reg: %b | write_data: %h | reg_write: %b | read_data1: %h | read_data2: %h\n",
               $time, reset, read_reg1, read_reg2, write_reg, write_data, reg_write, read_data1, read_data2);
   end

   // test 1
   initial begin



      reset = 1;
      read_reg1 = 5'b0;
      read_reg2 = 5'b0;
      write_reg = 5'b0;
      write_data = 32'b0;
      reg_write = 0;

      #15;
      reset = 0;

      #10;

      // preset the values of the registers
      REG.reg_array[5] = 32'h00000001;
      REG.reg_array[6] = 32'h00000002;

      read_reg1 = 5'h6;
      read_reg2 = 5'h5;


      $display("Read data 1: %h", read_data1);
      $display("Read data 2: %h", read_data2);
      #20;

      $display("Read data 1: %h", read_data1);
      $display("Read data 2: %h", read_data2);
      $stop;
   end

   // test 2
   // initial begin
   //    reset = 1;
   //    read_reg1 = 5'b0;
   //    read_reg2 = 5'b0;
   //    write_reg = 5'b0;
   //    write_data = 32'b0;
   //    reg_write = 0;

   //    #15;
   //    reset = 0;

   //    // test write
   //    #10;
   //    write_reg = 5'd1;
   //    write_data = 32'haaaabbbb;
   //    reg_write = 1;
   //    #10;
   //    reg_write = 0;

   //    // test read
   //    #10;
   //    read_reg1 = 5'd1;
   //    read_reg2 = 5'd0;
   //    #10;
   //    $display("Read data 1: %h (expected:aaaabbbb)", read_data1);
   //    $display("Read data 2: %h (expected:00000000)", read_data2);

   //    // test write to zero reg
   //    #10;
   //    write_reg = 5'd0;
   //    write_data = 32'hffffffff;
   //    reg_write = 1;
   //    #10;
   //    reg_write = 0;

   //    // check if zero reg value has changed
   //    #10;
   //    read_reg1 = 5'd0;
   //    read_reg2 = 5'd1;
   //    #10;
   //    $display("Read data 1: %h (expected:00000000)", read_data1);
   //    $display("Read data 2: %h (expected:aaaabbbb)", read_data2);
   //    $stop;

   // end


endmodule
