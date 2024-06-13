
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

   // declaration for control unit
   wire [3:0]                         alu_control;
   wire                               regwrite_control;

   // declaration for ALU
   wire [31:0]                        alu_result;
   wire                               zero_flag;

   // declaration for Register File
   wire [31:0]                        read_data1;
   wire [31:0]                        read_data2;


   IFU instruction_fetch_unit (
                               .clk(clk),
                               .reset(reset),
                               .branch_target(0),
                               .branch_taken(0),
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

   control control_unit (
                         .opcode(opcode),
                         .funct3(funct3),
                         .funct7(funct7),
                         .alu_control(alu_control),
                         .regwrite_control(regwrite_control)
                         );


   ALU arithmetic_logic_unit (
                              .in_a(rs1),
                              .in_b(rs2),
                              .alu_control(alu_control),
                              .alu_result(alu_result),
                              .zero_flag(zero_flag)
                              );

   register_file register_file_unit (
                                     .clk(clk),
                                     .reset(reset),
                                     .read_reg1(rs1),
                                     .read_reg2(rs2),
                                     .write_reg(rd),
                                     .write_data(alu_result),
                                     .reg_write(regwrite_control),
                                     .read_data1(read_data1),
                                     .read_data2(read_data2)
                                     );


endmodule
