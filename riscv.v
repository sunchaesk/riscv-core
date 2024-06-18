
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
   reg [2:0]                          imm_type;


   // control unit
   reg [3:0]                          alu_control;
   reg                                regwrite_control;
   reg                                imm_control;

   // alu
   reg [31:0]                         alu_result;
   reg                                zero_flag;

   // register file unit
   reg [31:0]                         read_data1;
   reg [31:0]                         read_data2;


   /////// Intermediates
   wire [31:0]                         operand_a;
   wire [31:0]                         operand_b;

   assign operand_a = read_data1;
   assign operand_b = (imm_control) ? imm : read_data2;

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
                        .imm(imm),
                        .imm_type(imm_type)
                        );

   control control_unit (
                         .opcode(opcode),
                         .funct3(funct3),
                         .funct7(funct7),
                         .alu_control(alu_control),
                         .regwrite_control(regwrite_control),
                         .imm_control(imm_control)
                         );

   ALU arithmetic_logic_unit(
                             .in_a(operand_a),
                             .in_b(operand_b),
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

   // assign output ports
   assign pc_out = pc;
   assign instruction_out = fetched_instruction;


endmodule
