module if_stage #(parameter N = 32)(
  input logic clk,rst,  
  input logic take_branch,
  input logic [N-1:0] branch_target,
  output logic[N-1:0] pc_out,	
  output logic[N-1:0] instr_out
);
  logic[N-1:0] pc;
  
  always_ff @(posedge clk or posedge rst) begin
      if (rst)
      pc <= 0;
    else
      pc <= take_branch ? branch_target : pc + 4;
  end

  assign pc_out = pc;
  rom #(.N(N)) rom_inst(
    .addr(pc_out), 
    .instr(instr_out)
    );
endmodule

