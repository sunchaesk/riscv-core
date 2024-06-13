module IFU (
            input wire         clk,
            input wire         reset,
            input wire [31:0]  branch_target,
            input wire         branch_taken,
            output wire [31:0] pc,
            output wire [31:0] instruction
            );

   reg [31:0]                  pc_reg; // ProgramCounter internal

   // instantiate memory for program counter
   reg [31:0]                  instruction_memory [255:0];

   always @(posedge clk or posedge reset) begin
      if (reset) begin
         pc_reg <= 32'b0;
      end else if (branch_taken) begin
         pc_reg <= branch_target;
      end else begin
         pc_reg <= pc_reg + 4;
      end
   end

   assign pc = pc_reg;

   always @(posedge clk) begin
      if (reset) begin
         instruction <= 32'b0;
      end else begin
         instruction <= instruction_memory[pc_reg[31:2]] // ?? TODO NOTE

endmodule
