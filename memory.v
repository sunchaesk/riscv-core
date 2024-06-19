
module memory (
                    input         clk,
                    input         reset,
                    input         mem_read_control,
                    input         mem_write_control,
                    input [31:0]  mem_data_in,
                    input [31:0]  address,
                    output reg [31:0] mem_data_out
                    );

   parameter                      MEMORY_SIZE = 256; // 1KB memory

   reg [31:0]                     memory [MEMORY_SIZE-1:0]; // memory init

   // memory read
   always @(*) begin
      if (mem_read_control) begin
         mem_data_out = memory[address[31:2]];
      end else begin
         mem_data_out = 32'b0;
      end
   end

   // memory write
   always @(posedge clk or posedge reset) begin
      if (reset) begin
         integer  i;
         for (i = 0; i < MEMORY_SIZE; i = i + 1) begin
            memory[i] <= 32'b0;
         end
      end else if (mem_write_control) begin
         memory[address[31:2]] <= mem_data_in;
      end
   end

endmodule
