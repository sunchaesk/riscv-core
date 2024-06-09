
module memory_unit(
                   data_in,
                   address,
                   clk,
                   write,
                   data_out
                   );

   parameter memory_size = 1024; // 1KB memory

   output [31:0] data_out;
   input [31:0]  data_in;
   input [31:0]  address;
   input         clk, write;
   reg [31:0]    memory [memory_size-1:0]; // memory init

   assign data_out = memory[address];
   always @(posedge clk)
     if (write) memory[address] = data_in;

endmodule
