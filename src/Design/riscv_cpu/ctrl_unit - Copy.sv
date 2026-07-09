module ctrl_unit (
  input  logic [6:0] opcode, funct7,
  input  logic [2:0] funct3,
  output logic [3:0] alu_ctrl,
  output logic       alu_src, reg_write, mem_read, mem_write,
  output logic       branch, jump, jalr, auipc
);
  always_comb begin
    alu_ctrl  = 4'b0000;
    alu_src   = 0;
    reg_write = 0;
    mem_read  = 0;
    mem_write = 0;
    branch    = 0;
    jump      = 0;
    jalr      = 0;
    auipc     = 0;
 
    case (opcode)
      // R-type
      7'b0110011: begin
        reg_write = 1;
        alu_src   = 0;
        case (funct3)
          3'b000: alu_ctrl = funct7[5] ? 4'b0001 : 4'b0000; // SUB : ADD
          3'b001: alu_ctrl = 4'b0101; // SLL
          3'b010: alu_ctrl = 4'b1000; // SLT
          3'b011: alu_ctrl = 4'b1001; // SLTU
          3'b100: alu_ctrl = 4'b0100; // XOR
          3'b101: alu_ctrl = funct7[5] ? 4'b0111 : 4'b0110; // SRA : SRL
          3'b110: alu_ctrl = 4'b0011; // OR
          3'b111: alu_ctrl = 4'b0010; // AND
          default: alu_ctrl = 4'b0000;
        endcase
      end
 
      // I-type ALU
      7'b0010011: begin
        reg_write = 1;
        alu_src   = 1;
        case (funct3)
          3'b000: alu_ctrl = 4'b0000; // ADDI
          3'b010: alu_ctrl = 4'b1000; // SLTI
          3'b011: alu_ctrl = 4'b1001; // SLTIU
          3'b100: alu_ctrl = 4'b0100; // XORI
          3'b110: alu_ctrl = 4'b0011; // ORI
          3'b111: alu_ctrl = 4'b0010; // ANDI
          3'b001: alu_ctrl = 4'b0101; // SLLI
          3'b101: alu_ctrl = funct7[5] ? 4'b0111 : 4'b0110; // SRAI : SRLI
          default: alu_ctrl = 4'b0000;
        endcase
      end
 
      // I-type Load
      7'b0000011: begin
        reg_write = 1;
        alu_src   = 1;
        mem_read  = 1;
        alu_ctrl  = 4'b0000; // ADD for address calc
      end
 
      // S-type
      7'b0100011: begin
        alu_src   = 1;
        mem_write = 1;
        alu_ctrl  = 4'b0000; // ADD for address calc
      end
 
      // B-type
      7'b1100011: begin
        alu_src = 0;
        branch  = 1;
        case (funct3)
          3'b000: alu_ctrl = 4'b0001; // BEQ  -> SUB, check zero
          3'b001: alu_ctrl = 4'b0001; // BNE  -> SUB, check not zero
          3'b100: alu_ctrl = 4'b1000; // BLT  -> SLT, check result == 1
          3'b101: alu_ctrl = 4'b1000; // BGE  -> SLT, check result == 0
          3'b110: alu_ctrl = 4'b1001; // BLTU -> SLTU, check result == 1
          3'b111: alu_ctrl = 4'b1001; // BGEU -> SLTU, check result == 0
          default: alu_ctrl = 4'b0001;
        endcase
      end
 
      // JAL
      7'b1101111: begin
        reg_write = 1;
        jump      = 1;
      end
 
      // JALR
      7'b1100111: begin
        reg_write = 1;
        alu_src   = 1;
        jump      = 1;
        jalr      = 1;
        alu_ctrl  = 4'b0000;
      end
 
      // LUI
      7'b0110111: begin
        reg_write = 1;
        alu_src   = 1;
        alu_ctrl  = 4'b0000;
      end
 
      // AUIPC
      7'b0010111: begin
        reg_write = 1;
        auipc     = 1;
      end
 
    endcase
  end
endmodule
