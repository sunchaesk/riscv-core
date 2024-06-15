
module riscv_processor (
                        input         clk,
                        input         reset,
                        output [31:0] pc_out,
                        output [31:0] instruction_out
                        );

   // pc stuff (IFU)
   reg [31:0]                         pc;
   reg [31:0]                         fetched_instruction;

   // decoder initializes (decoder)
   reg [6:0]                          opcode;
   reg [2:0]                          funct3;
   reg [6:0]                          funct7;
   reg [4:0]                          rd;
   reg [4:0]                          rs1;
   reg [4:0]                          rs2;
   reg [31:0]                         imm;

   IFU instruction_fetch_unit (
                               .clk(clk),
                               .reset(reset),
                               .branch_target(32'b0),
                               .branch_taken(1'b0),
                               .pc(pc),
                               .instruction(fetched_instruction)
                               );

   decoder decode_unit (
                        .instruction(fetched_instruction),
                        .opcode(opcode),
                        .funct3(funct3),
                        .funct7(funct7),
                        .rd(rd),
                        .rs1(rs1),
                        .rs2(rs2),
                        .imm(imm)
                        );



   // assign output ports
   assign pc_out = pc;
   assign instruction_out = fetched_instruction;


endmodule
