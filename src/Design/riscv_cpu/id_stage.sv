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
            // R-type
            7'b0110011: begin
                rs1_addr = instr[19:15];
                rs2_addr = instr[24:20];
            end
            
            // B-type
            7'b1100011: begin
                rs1_addr = instr[19:15];
                rs2_addr = instr[24:20];
            end
            
            // S-type
            7'b0100011: begin
                rs1_addr = instr[19:15];  
                rs2_addr = instr[24:20]; 
            end
            
            // I-type 
            7'b0010011: begin
                rs1_addr = instr[19:15];  
                
            end
            
            // I-type Load
            7'b0000011: begin
                rs1_addr = instr[19:15];  
        
            end
            
            // I-type JALR
            7'b1100111: begin
                rs1_addr = instr[19:15];  
               
            end
            
            default: begin
            end
        endcase
    end
    
    // Immediate generation for all instruction types
    always_comb begin
        case (opcode)
            7'b0010011,  // I-type ALU
            7'b0000011,  // I-type Load
            7'b1100111:  // I-type JALR
                imm = {{20{instr[31]}}, instr[31:20]};
                
            // S-type 
            7'b0100011:  // SW, SH, SB
                imm = {{20{instr[31]}}, instr[31:25], instr[11:7]};
                
            // B-type 
            7'b1100011:  
                imm = {{19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0};
                
            // U-type 
            7'b0110111,  // LUI
            7'b0010111:  // AUIPC
                imm = {instr[31:12], 12'b0};
                
            // J-type 
            7'b1101111:  // JAL
                imm = {{12{instr[31]}}, instr[19:12], instr[20], instr[30:21], 1'b0};
                
        
            default:
                imm = 32'd0;
        endcase
    end
    
    regfile #(.N(N)) rf (
        .clk(clk),
        .we(we),
        .reset(rst),
        .rd_addr(rd_wb),           
        .rs1_addr(rs1_addr),       
        .rs2_addr(rs2_addr),      
        .wd(wd_wb),               
        .rs1_data(rs1_data),     
        .rs2_data(rs2_data)       
    );
    
endmodule
