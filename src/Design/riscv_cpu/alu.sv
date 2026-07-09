module alu  #(parameter N = 32)(
  input  logic [N-1:0] op1,
  input  logic [N-1:0] op2,
  input  logic [3:0]  alu_ctrl,
  output logic [N-1:0] result
);

    always_comb begin
        case (alu_ctrl)
            4'b0000: result = op1 + op2;                      // ADD
            4'b0001: result = op1 - op2;                      // SUB
            4'b0010: result = op1 & op2;                      // AND
            4'b0011: result = op1 | op2;                      // OR
            4'b0100: result = op1 ^ op2;                      // XOR
            4'b0101: result = op1 << op2[4:0];                // SLL
            4'b0110: result = op1 >> op2[4:0];                // SRL
            4'b0111: result = $signed(op1) >>> op2[4:0];      // SRA
            4'b1000: result = ($signed(op1) < $signed(op2)) ? 32'd1 : 32'd0; // SLT
            4'b1001: result = (op1 < op2) ? 32'd1 : 32'd0;     // SLTU
            default: result = {N{1'b0}};      // default to the msb but in decimal compared to binary, wider index given the 32-bit
        endcase
    end
endmodule

