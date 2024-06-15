
module riscv_processor (
                   input         clk,
                   input         reset,
                   output [31:0] pc_out,
                   output [31:0] instruction_out
                   );

   // pc stuff (IFU)
   reg [31:0]                   pc;
   reg [31:0]                   fetched_instruction;

   // decoder initializes (decoder)


   IFU instruction_fetch_unit (
                               .clk(clk),
                               .reset(reset),
                               .branch_target(32'b0),
                               .branch_taken(1'b0),
                               .pc(pc),
                               .instruction(fetched_instruction)
                               );

   // decoder decode_unit (
   //                      .instruction(fetched_instruction),

   //                      );



   // assign output ports
   assign pc_out = pc;
   assign instruction_out = fetched_instruction;


endmodule
