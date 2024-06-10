
module riscv_processor (
                        input         clk,
                        input         reset,
                        output [31:0] pc_out;
                        output [31:0] instruction_out;
                        );

   // PC stuff
   wire [31:0]                        pc;
   wire [31:0]                        fetched_instruction;
   wire                               branch_taken;
   wire [31:0]                        branch_target;


   // declaration for decoder
   wire [6:0]                         opcode;
   wire [2:0]                         funct3;
   wire [6:0]                         funct7;
   wire [4:0]                         rd;
   wire [4:0]                         rs1;
   wire [4:0]                         rs2;
   wire [31:0]                        imm;



   IFU instruction_fetch_unit (
                               .clk(clk),
                               .reset(reset),
                               .branch_target(),
                               .branch_taken(),
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


   register_file register_file_unit (
                                     .clk(clk),
                                     .reset(reset),
                                     .read_reg1(),
                                     .read_reg2(),
                                     .write_reg(),
                                     .write_data(),
                                     .reg_write(),
                                     .read_data1(),
                                     .read_data2()
                                     );


   ALU arithmetic_logic_unit (
                              .in_a(),
                              .in_b(),
                              .alu_control(),
                              .zero_flag()
                              );


endmodule
