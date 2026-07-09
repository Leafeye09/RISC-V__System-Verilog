module id_stage #(parameter N = 32)(
    input  logic clk, rst, we,
    input  logic [N-1:0] instr,              
    input  logic [4:0] rd_wb,                 
    input  logic [N-1:0] wd_wb,               
    output logic [4:0] rs1_addr,rs2_addr,rd_addr,               
    output logic [N-1:0] rs1_data,rs2_data,imm,                 
    output logic [6:0] opcode,funct7,
    output logic [2:0] funct3
);

    assign opcode = instr[6:0];
    assign funct3 = instr[14:12];
    assign funct7 = instr[31:25];
    assign rd_addr = instr[11:7];
    
    always_comb begin
        rs1_addr = 5'd0;
        rs2_addr = 5'd0;
        case (opcode)
            // R-type: ADD, SUB, AND, OR, XOR, SLL, SRL, SRA, SLT, SLTU
            7'b0110011: begin
                rs1_addr = instr[19:15];
                rs2_addr = instr[24:20];
            end
            
            // B-type: BEQ, BNE, BLT, BGE, BLTU, BGEU  
            7'b1100011: begin
                rs1_addr = instr[19:15];
                rs2_addr = instr[24:20];
            end
            
            // S-type: SW, SH, SB
            7'b0100011: begin
                rs1_addr = instr[19:15];  // Base address
                rs2_addr = instr[24:20];  // Source data
            end
            
            // I-type ALU: ADDI, SLTI, SLTIU, XORI, ORI, ANDI, SLLI, SRLI, SRAI
            7'b0010011: begin
                rs1_addr = instr[19:15];  // Source operand
                // rs2_addr = 0 (not used for immediate operations)
            end
            
            // I-type Load: LW, LH, LB, LHU, LBU
            7'b0000011: begin
                rs1_addr = instr[19:15];  // Base address
                // rs2_addr = 0 (not used for loads)
            end
            
            // I-type JALR
            7'b1100111: begin
                rs1_addr = instr[19:15];  // Base address for jump
                // rs2_addr = 0 (not used for JALR)
            end
            
            // U-type: LUI, AUIPC - no source registers needed
            // J-type: JAL - no source registers needed
            default: begin
                // rs1_addr = 0, rs2_addr = 0 (already assigned above)
            end
        endcase
    end
    
    // Immediate generation for all instruction types
    always_comb begin
        case (opcode)
            // I-type instructions: 12-bit immediate, sign-extended
            7'b0010011,  // I-type ALU (ADDI, SLTI, etc.)
            7'b0000011,  // I-type Load (LW, LH, LB, etc.)
            7'b1100111:  // I-type JALR
                imm = {{20{instr[31]}}, instr[31:20]};
                
            // S-type instructions: Store immediate, sign-extended
            7'b0100011:  // SW, SH, SB
                imm = {{20{instr[31]}}, instr[31:25], instr[11:7]};
                
            // B-type instructions: Branch immediate, sign-extended, shifted left by 1
            7'b1100011:  // BEQ, BNE, BLT, BGE, BLTU, BGEU
                imm = {{19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0};
                
            // U-type instructions: Upper immediate, shifted left by 12
            7'b0110111,  // LUI
            7'b0010111:  // AUIPC
                imm = {instr[31:12], 12'b0};
                
            // J-type instructions: Jump immediate, sign-extended, shifted left by 1
            7'b1101111:  // JAL
                imm = {{12{instr[31]}}, instr[19:12], instr[20], instr[30:21], 1'b0};
                
            // Default case for unsupported instructions
            default:
                imm = 32'd0;
        endcase
    end
    
    // Instantiate regfile
    regfile #(.N(N)) rf (
        .clk(clk),
        .we(we),
        .reset(rst),
        .rd_addr(rd_wb),           // Writeback address
        .rs1_addr(rs1_addr),       // Source 1 address
        .rs2_addr(rs2_addr),       // Source 2 address
        .wd(wd_wb),               // Writeback data
        .rs1_data(rs1_data),      // Source 1 data output
        .rs2_data(rs2_data)       // Source 2 data output
    );
    
endmodule
