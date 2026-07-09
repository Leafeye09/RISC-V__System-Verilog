module ex_stage #(parameter N = 32)(
  input  logic [N-1:0] rs1_data,
  input  logic [N-1:0] rs2_data,
  input  logic [N-1:0] pc,
  input  logic [N-1:0] imm,
  input  logic [2:0]   funct3,
  input  logic [3:0]   alu_ctrl,
  input  logic         alu_src, branch, jump, jalr,
  output logic [N-1:0] alu_result,
  output logic [N-1:0] branch_target,
  output logic [N-1:0] rs2_out,
  output logic [N-1:0] pc_plus4,
  output logic         take_branch
);
  logic [N-1:0] alu_input_b;
  logic         alu_zero;
 
  assign alu_input_b = alu_src ? imm : rs2_data;
  assign alu_zero    = (alu_result == {N{1'b0}});
  assign pc_plus4    = pc + 4;
 
  alu #(.N(N)) alu_calc(
    .op1(rs1_data),
    .op2(alu_input_b),
    .alu_ctrl(alu_ctrl),
    .result(alu_result)
  );
 
  assign branch_target = jalr ? ((rs1_data + imm) & ~{{(N-1){1'b0}}, 1'b1}) : pc + imm;
 
  always_comb begin
    take_branch = 1'b0;
    if (branch) begin
      case (funct3)
        3'b000: take_branch = alu_zero;
        3'b001: take_branch = ~alu_zero;
        3'b100: take_branch = (alu_result == {{(N-1){1'b0}}, 1'b1});
        3'b101: take_branch = (alu_result == {N{1'b0}});
        3'b110: take_branch = (alu_result == {{(N-1){1'b0}}, 1'b1});
        3'b111: take_branch = (alu_result == {N{1'b0}});
        default: take_branch = 1'b0;
      endcase
    end else if (jump) begin
      take_branch = 1'b1;
    end
  end
 
  assign rs2_out = rs2_data;
 
endmodule
