module decoder(
               input [31:0]      instruction,
               output reg [6:0]  opcode,
               output reg [2:0]  funct3,
               output reg [6:0]  funct7,
               output reg [4:0]  rd,
               output reg [4:0]  rs1,
               output reg [4:0]  rs2,
               output reg [31:0] imm,
               output reg [2:0]  imm_type
               );

   // comb circuit
   always @(*) begin
      opcode = instruction[6:0];
      rd = instruction[11:7];
      funct3 = instruction[14:12];
      rs1 = instruction[19:15];
      rs2 = instruction[24:20];
      funct7 = instruction[31:25];

      // initialize default value for imm
      imm = 32'b0;

      // dealing with imm instructions
      case(opcode)
        7'b0010011: begin // I-type
           imm = {{20{instruction[31]}}, instruction[30:20]};
           imm_type = 3'b000;
        end
        7'b0000011: begin // Load (subset of I-type)
           imm = {{20{instruction[31]}}, instruction[30:20]};
           imm_type = 3'b000; // load instructions have different opcodes but same imm_type code NOTE
        end
        7'b0100011: begin// S-type
           imm = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};
           imm_type = 3'b001;
        end
        7'b1100011: begin // B-type
           imm = {{19{instruction[31]}}, instruction[7], instruction[30:25], instruction[11:8], 1'b0};
           imm_type = 3'b010;
        end
        // 7'b0110111,
        //   7'b0010111: begin // U-type
        //      imm = {instruction[31], instruction[30:20], instruction[19:12], {11{1'b0}}};
        //      imm_type = 3'b011;
        //   end
        7'b1101111: begin // jal
           imm = {instruction[31], instruction[19:12], instruction[20], instruction[30:25], instruction[24:21], 1'b0};
           imm_type = 3'b100;
        end
        7'b1100111: begin // jalr (I-instruction)
           imm = {{20{instruction[31]}}, instruction[30:20]};
           imm_type = 3'b000;
        end
        7'b0110111,
        7'b0010111: begin // U-type instruction
           imm = {instruction[31:12], 12'b0};
           imm_type = 3'b011;
        end
      endcase
   end
endmodule
