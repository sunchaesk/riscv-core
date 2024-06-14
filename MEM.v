
module memory_unit (
                    input         clk,
                    input         write,
                    input [31:0]  data_in,
                    input [31:0]  address,
                    output [31:0] data_out
                    );

   parameter                      MEMORY_SIZE = 1024; // 1KB memory

   reg [31:0]                     memory [MEMORY_SIZE-1:0]; // memory init

   assign data_out = memory[address];
   always @(posedge clk) begin
      if (write) begin
         memory[address] = data_in;
      end
   end

endmodule
