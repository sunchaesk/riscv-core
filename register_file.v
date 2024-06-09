
// read_data1&2 is for instance, pipeline it to CPU
// you have 2 output ports so that two operands of ALU can be fetched
// in a single cycle
module register_file (
                      input         clk,
                      input         reset,
                      input [4:0]   read_reg1,
                      input [4:0]   read_reg2,
                      input [4:0]   write_reg,
                      input [31:0]  write_data,
                      input         reg_write,
                      output [31:0] read_data1,
                      output [31:0] read_data2
                      );

   // 32 registers
   reg [31:0]                       reg_array [31:0];

   // reset the registers on active high reset signal
   integer                          i;
   always @(posedge clk) begin
      if (reset) begin
         for (i = 0; i < 32; i = i + 1) begin
            reg_array[i] = 32'b0;
         end
      end else begin
         // first register (5'b0) is the zero register (always zero)
         if (reg_write && (write_reg != 5'b0)) begin
            reg_array[write_red] <= write_data;
         end
      end
   end

   assign read_data1 = (read_reg1 == 5'b0) ? 32'b0 : reg_array[read_reg1];
   assign read_data2 = (read_reg2 == 5'b0) ? 32'b0 : reg_array[read_reg2];

endmodule
