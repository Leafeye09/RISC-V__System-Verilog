module top_level #(parameter N = 32)(
  input  logic        clk, rst,
  input  logic [4:0]  reg_sel,
  output logic [N-1:0] reg_out
);
 
  // IF wires connected 
  logic [N-1:0] pc, instr;
 
  // ID wires
  logic [N-1:0] rs1_data, rs2_data, imm;
  logic [4:0]   rs1_addr, rs2_addr, rd_addr;
  logic [6:0]   opcode, funct7;
  logic [2:0]   funct3;
 
  // Control signals connected
  logic [3:0]   alu_ctrl;
  logic         alu_src, reg_write, mem_read, mem_write;
  logic         branch, jump, jalr, auipc;
 
  // EX wires
  logic [N-1:0] alu_result, branch_target, pc_plus4;
  logic         take_branch;
 
  // Writeback mux: jump -> pc+4, auipc -> pc+imm, else -> alu_result
  logic [N-1:0] wb_data;
  always_comb begin
    if (jump)       wb_data = pc_plus4;
    else if (auipc) wb_data = pc + imm;
    else            wb_data = alu_result;
  end
 
  // IF stage connected 
  if_stage #(.N(N)) if_inst (
    .clk          (clk),
    .rst          (rst),
    .take_branch  (take_branch),
    .branch_target(branch_target),
    .pc_out       (pc),
    .instr_out    (instr)
  );
 
  // ID stage connected 
  id_stage #(.N(N)) id_inst (
    .clk      (clk),
    .rst      (rst),
    .we       (reg_write),
    .instr    (instr),
    .rd_wb    (rd_addr),
    .wd_wb    (wb_data),       
    .rs1_addr (rs1_addr),
    .rs2_addr (rs2_addr),
    .rd_addr  (rd_addr),
    .rs1_data (rs1_data),
    .rs2_data (rs2_data),
    .imm      (imm),
    .opcode   (opcode),
    .funct3   (funct3),
    .funct7   (funct7)
  );
 
  // Control unit connected 
  ctrl_unit ctrl_inst (
    .opcode   (opcode),
    .funct3   (funct3),
    .funct7   (funct7),
    .alu_ctrl (alu_ctrl),
    .alu_src  (alu_src),
    .reg_write(reg_write),
    .mem_read (mem_read),
    .mem_write(mem_write),
    .branch   (branch),
    .jump     (jump),
    .jalr     (jalr),
    .auipc    (auipc)
  );
 
  // EX stage connected
  ex_stage #(.N(N)) ex_inst (
    .rs1_data     (rs1_data),
    .rs2_data     (rs2_data),
    .pc           (pc),
    .imm          (imm),
    .alu_ctrl     (alu_ctrl),
    .alu_src      (alu_src),
    .branch       (branch),
    .jump         (jump),
    .jalr         (jalr),
    .alu_result   (alu_result),
    .branch_target(branch_target),
    .rs2_out      (),
    .pc_plus4     (pc_plus4),
    .take_branch  (take_branch),
    .funct3       (funct3)
  );
 
  assign reg_out = id_inst.rf.regs[reg_sel]; 
 
endmodule
