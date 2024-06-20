// working on second version because the first version output data not working
module register_file (
                      input         clk,
                      input         reset,
                      input         reg_write,
                      input [4:0]   read_reg1,
                      input [4:0]   read_reg2,
                      input [4:0]   write_reg,
                      input [31:0]  write_data,
                      output [31:0] read_data1,
                      output [31:0] read_data2
                      );

   reg [31:0]                       reg_array [31:0];

   integer                          i;
   always @(posedge reset) begin
      for (i = 0; i < 32; i = i + 1) begin
         reg_array[i] <= 32'b0;
      end
   end

   assign read_data1 = reg_array[read_reg1];
   assign read_data2 = reg_array[read_reg2];

   always @(posedge clk) begin
      if (reg_write) begin
         reg_array[write_reg] <= write_data;
      end
   end


endmodule
