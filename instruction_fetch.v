module IFU (
            input wire        clk,
            input wire        reset,
            input wire [31:0] branch_target,
            input wire        branch_taken,
            input wire [31:0] jump_target,
            input wire        jump_taken,
            output reg [31:0] pc,
            output reg [31:0] instruction
            );

   reg [31:0]                 pc_reg; // Program Counter internal
   reg [31:0]                 next_pc; // Temporary next PC value

   // Instantiate memory for program counter
   reg [31:0]                 instruction_memory [255:0];

   // Combinational logic to determine the next PC value
   always @(*) begin
      if (jump_taken) begin
         next_pc = jump_target;
      end else if (branch_taken) begin
         next_pc = branch_target;
      end else begin
         next_pc = pc + 4;
      end
   end
   // always @(*) begin
   //    if (branch_taken) begin
   //       next_pc = branch_target;
   //    end else begin
   //       next_pc = pc_reg + 4;
   //    end
   // end

   // Sequential logic to update the PC register
   always @(posedge clk or posedge reset) begin
      if (reset) begin
         pc_reg <= 32'b0;
      end else begin
         pc_reg <= next_pc;
      end
   end

   // Assign the current PC value to the output
   assign pc = pc_reg;

   // Sequential logic to fetch the instruction
   always @(posedge clk or posedge reset) begin
      if (reset) begin
         instruction <= 32'b0;
      end else begin
         instruction <= instruction_memory[next_pc[31:2]];  // Fetch the instruction using next_pc
      end
   end

endmodule

// module IFU (
//     input wire         clk,
//     input wire         reset,
//     input wire [31:0]  branch_target,
//     input wire         branch_taken,
//     output reg [31:0]  pc,
//     output reg [31:0]  instruction
// );

//     reg [31:0] pc_reg; // Program Counter internal
//     reg [31:0] next_pc; // Temporary next PC value

//     // instantiate memory for program counter
//     reg [31:0] instruction_memory [255:0];

//     // Combinational logic to determine the next PC value
//     always @(*) begin
//         if (branch_taken) begin
//             next_pc = branch_target;
//         end else begin
//             next_pc = pc_reg + 4;
//         end
//     end

//     // Sequential logic to update the PC register and fetch instruction
//     always @(posedge clk or posedge reset) begin
//         if (reset) begin
//             pc_reg <= 32'b0;
//         end else begin
//             pc_reg <= next_pc;
//         end
//     end

//     // Assign the current PC value to the output
//     assign pc = pc_reg;

//     // Fetch the instruction based on the updated PC value
//     always @(posedge clk or posedge reset) begin
//         if (reset) begin
//             instruction <= 32'b0;
//         end else begin
//             instruction <= instruction_memory[next_pc[31:2]];  // Fetch the instruction using next_pc
//         end
//     end

// endmodule
// module IFU (
//             input wire         clk,
//             input wire         reset,
//             input wire [31:0]  branch_target,
//             input wire         branch_taken,
//             output reg [31:0] pc,
//             output reg [31:0] instruction
//             );

//    reg [31:0]                  pc_reg; // ProgramCounter internal

//    // instantiate memory for program counter
//    reg [31:0]                  instruction_memory [255:0];

//    always @(posedge clk or posedge reset) begin
//       if (reset) begin
//          pc_reg <= 32'b0;
//       end else if (branch_taken) begin
//          pc_reg <= branch_target;
//       end else begin
//          pc_reg <= pc_reg + 4;
//       end
//    end

//    assign pc = pc_reg;

//    always @(posedge clk) begin
//       if (reset) begin
//          instruction <= 32'b0;
//       end else begin
//          instruction <= instruction_memory[pc_reg[31:2]];  // ?? TODO NOTE
//       end
//    end

// endmodule
// UP is previous one NOTE

// module IFU (
//     input wire         clk,
//     input wire         reset,
//     input wire [31:0]  branch_target,
//     input wire         branch_taken,
//     output reg [31:0]  pc,
//     output reg [31:0]  instruction
// );

//     reg [31:0] pc_reg; // Program Counter internal

//     // instantiate memory for program counter
//     reg [31:0] instruction_memory [255:0];

//     always @(posedge clk or posedge reset) begin
//         if (reset) begin
//             pc_reg <= 32'b0;
//         end else begin
//             pc_reg <= (branch_taken) ? branch_target : pc_reg + 4;
//         end
//     end

//     assign pc = pc_reg;

//     always @(posedge clk or posedge reset) begin
//         if (reset) begin
//             instruction <= 32'b0;
//         end else begin
//             instruction <= instruction_memory[pc_reg[31:2]];  // Fetch the instruction
//         end
//     end

// endmodule


// module IFU (
//     input wire         clk,
//     input wire         reset,
//     input wire [31:0]  branch_target,
//     input wire         branch_taken,
//     output reg [31:0]  pc,
//     output reg [31:0]  instruction
// );

//     reg [31:0] pc_reg; // Program Counter internal
//     reg [31:0] next_pc; // Next Program Counter

//     // instantiate memory for program counter
//     reg [31:0] instruction_memory [255:0];

//     always @(posedge clk or posedge reset) begin
//         if (reset) begin
//             pc_reg <= 32'b0;
//         end else begin
//             pc_reg <= next_pc;
//         end
//     end

//     always @(*) begin
//         if (reset) begin
//             next_pc = 32'b0;
//         end else if (branch_taken) begin
//             next_pc = branch_target;
//         end else begin
//             next_pc = pc_reg + 4;
//         end
//     end

//     assign pc = pc_reg;

//     always @(posedge clk or posedge reset) begin
//         if (reset) begin
//             instruction <= 32'b0;
//         end else begin
//             instruction <= instruction_memory[pc_reg[31:2]];  // Fetch the instruction
//         end
//     end

// endmodule

