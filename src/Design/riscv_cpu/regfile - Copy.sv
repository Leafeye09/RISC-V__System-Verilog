module regfile #(parameter N = 32)(
  input  logic        clk,we,reset,              // Write enable and clock
  input  logic  [4:0] rd_addr,          // Destination register address
  input  logic  [4:0] rs1_addr, rs2_addr, // Source register addresses
  input  logic [N-1:0] wd,               // Write data
  output logic [N-1:0] rs1_data, rs2_data
  // Read data outputs
);

  logic [N-1:0] regs [0:31]; // 32 registers of 32 bits

    // Read logic (combinational)
    assign rs1_data = (rs1_addr == 5'd0) ? 32'd0 : regs[rs1_addr];
    assign rs2_data = (rs2_addr == 5'd0) ? 32'd0 : regs[rs2_addr];

    // Write logic (sequential)
  always_ff @(posedge clk) begin
  if (reset) begin
    for (int i = 0; i < 32; i++)
      regs[i] <= {N{1'b0}};
  end else if (we && rd_addr != 5'd0) begin
    regs[rd_addr] <= wd;
  end
end


endmodule
